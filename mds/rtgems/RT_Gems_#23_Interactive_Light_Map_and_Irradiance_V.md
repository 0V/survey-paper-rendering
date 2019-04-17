# RT Gems #23 Interactive Light Map and Irradiance Volume Preview in Frostbite

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555416104561_95o5taasvtb01.png)



## Irradiance volumes

p380

spherical harmomics coefficient
おそらく球面調和関数の引数

球面調和関数はラプラス方程式の解を単位球面に制限したもの。

三次元空間なので、球座標でラプラス方程式の解を表現したときの変数分離解、*Y* ^*n _k* (*θ*, *φ*)。

したがって自由度は二次元。

Irradiance volumeはこの係数データを三次元グリッドに保持しているもの。


## BVH


> The bottom level contains a BVH for each unique mesh. The top level contains all instances, each of which has a unique spatial transform and references a bottom-level BVH node.

BVHは二つのレベルを持つ。BottomレベルはメッシュのBVH、Topレベルはすべてのインスタンスをもち、それぞれ固有のtransformとbottomレベルBVHノードへの参照を持つ。

１レベルのBVH構造に比べてトラバーサルの効率が落ちる代わりにシーンのアップデートが容易になる。


> moving a mesh requires updating only the top-level instance transform matrix,

例えば、メッシュの移動はtopレベルインスタンスのtransform matrixを変更するのみでよい。bottom levelはいじらないですむ。



# GI solver pipeline


- **Update scene**: All scene modifications since the last iteration are applied, e.g., moving a mesh or changing a light’s color. These inputs are translated and uploaded to the GPU. See Section 23.4.
- **Update caches**: If invalidated or incomplete, the irradiance caches are refined by tracing additional rays for estimating the incident direct irradiance. These caches are used for accelerating the tracing step. See Section 23.3.3.
- **Schedule texels**: Based on the camera’s view frustum, the most relevant visible light map texels and visible irradiance volumes are identified and scheduled for the tracing step. See Section 23.3.1.
- **Trace texels**: Each scheduled texel and irradiance point is refined by tracing a set of paths. These paths allow one to compute the incoming irradiance, as well as sky visibility and ambient occlusion. See Section 23.2.3.
- **Merge texels**: The newly computed irradiance samples are accumulated into persistent output resources. See Section 23.2.6.
- **Post-process outputs**: Dilation and denoising post-process passes are applied to the outputs, giving users a noise-free estimate of the converged output. See Section 23.2.8.


![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555325937484_image.png)





## irradiance E

放射照度 E, （入射してくる）放射輝度 L, 半球 Ω

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555406221978_image.png)

## light transport equation

Diffuse material only

$$L_e$$ emission,  $$\rho$$ albedo,  $$L_i$$ incident light

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555406018629_image.png)


**MC**
$$p_{L_\xi}$$ : pdf

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555406887210_image.png)


高次元な方程式を解くのは困難なので、Monte Carlo法を用いる。MC法を用いる根拠は３つ。


1. unbiased 推定量の期待値が母集団の真の値と一致する性質。
2. 結果は反復法により計算でき、アーティストによるインクリメンタルな修正[と適している
3. ライトマップのテクセル修正は独立しているために並列化可能


## simple light integration


テクセル上の点から光源を結ぶパスを生成。

Ray r はテクセルに飛んでくる光。
pathThroughput はalbedoなどによって減らされる光のスループット。この値により輸送される光の量が決まる。

BAD : this is rather slow and does not scale well

Following list describes a way of integrating the irradiance for each texel.

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555408122078_image.png)

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555408137512_image.png)



## 改善案

**importance sampling**
効率的なpdf

**generation random number**
最初のRayを飛ばす方向を、できる限り推定irradianceの分散が少なくなるように取りたい。


- low-discrepancy sequence :超一様分布列。

low-discrepancy sequenceを使う。乱数らしさはいらない。一様に分布している乱数らしきものがほしい。少ないサンプリング数でも偏りが出ない方が良いため。
今回はHalton sequence。全値域で一様にサンプリングされることが保証されている。

https://en.wikipedia.org/wiki/Low-discrepancy_sequence
ほかにHammersley pointsなど


**Halton sequence**
1. 底を決める．例えば2．
2. 順番に数をカウントアップする．1,2,3,4,5,6,7…
3. それらを2進数表記して，小数点以下から逆に読み，また10進数表記に戻す．
2進数小数は小数点以下から順に1/2の位，1/4の位，1/8の位,,,と読んでいく．（と自然数の底変換と整合性が取れる．）

左、疑似乱数　右、**Halton sequence**　

![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555411875932_image.png)
![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555411889310_image.png)


CC BY-SA 3.0Jheald https://commons.wikimedia.org/wiki/File:Pseudorandom_sequence_2D.svg, https://commons.wikimedia.org/wiki/File:Halton_sequence_2D.svg


## **Halton sequence の相関問題**
## 
> Even though standard Halton sequences perform very well in low dimensions, correlation problems have been noted between sequences generated from higher primes. For example, if we started with the primes 17 and 19, the first 16 pairs of points: (1⁄17, 1⁄19), (2⁄17, 2⁄19), (3⁄17, 3⁄19) ... (16⁄17, 16⁄19) would have perfect [linear correlation](https://en.wikipedia.org/wiki/Linear_correlation). 
> via Wikipedia: https://en.wikipedia.org/wiki/Halton_sequence


halton 列は低次元でよく機能する。しかし大きい素数から生成された場合、生成された点に相関が発生する場合がある。

ここではこの問題を回避のためにrandom jitter（乱数生成されたぶれ）をオフセット方向に加える。
２つの独立した２次元列としてサンプリングするのではなく、４次元空間からサンプリングすることで空間のサンプリングを効率化できる。これにより四次元空間（３次元空間＋角度）ですべての値域に一様分布することを保証できる。

**next event estimation**
光源がローカルポイントライトしかない場合、ランダムに飛ばして光源に到達するのにかかるパスは非常に長くなる。そのため光源と頂点を繋げてその寄与を計算する next event estimation が用いられる。これにより、各頂点と光源のサブパスを再利用しつつ光源の影響を計算できる。
シンプルだが非常によく収束する。
ただし、二重の光源寄与を防ぐために、ここで用いる光源は通常のシーンジオメトリからは除く。


##  light integration of production
![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555408049471_image.png)




# LIGHT SOURCES


## area light
![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555412698535_image.png)



## translucency
![](https://paper-attachments.dropbox.com/s_71FE04CA71DF5C04D9FF8215AD43A86832FC9550C6DD61209E559B0323F5BC70_1555482963510_image.png)


パラメーターは surface albedo と translucency factor.
これらのパラメーターをもとに確率的に反射とtransmitを選択する。











