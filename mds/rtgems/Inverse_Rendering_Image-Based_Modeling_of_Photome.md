# Inverse Rendering: Image-Based Modeling of Photometric Aspects インバースレンダリング：画像からの光学情報の復元


# Cite

佐藤洋一
Yoichi Sato
東京大学生産技術研究所

投稿先：SSII05（第11回 画像センシングシンポジウム）のチュートリアルセッション（見つけるの大変だった）
http://www.ssii.jp/05/SSII05-program6_1.pdf

# Abstract 

インバースレンダリングのサーベイ論文


# Introduction
## modeling from reality

現実に存在する物質の観察からモデルを生成


## image-based modeling

画像を対象としたmodeling from reality.


## inverse rendering 

image-based modeling のひとつ。レンダリングの引数であるところの下記を一枚ないし複数画像から推定する

- 幾何形状
- 反射特性
- 光源分布


## image-based rendering 

image-based modeling のひとつ。物体の見え方を三次元空間中の反射光の分布として表現。


## 比較

inverse rendering は物体の反射特性と光源分布を別に取り扱う。一方image-based renderingではある光源下での反射光そのものを記録するため、反射特性と光源分布を別に取り扱わない。そのため、入力画像と異なった光源のときのレンダリングが難しい。


# inverse rendering の基本
## レンダリング方程式

ある点rで方向ωに反射される輝度。

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555650481264_image.png)


これをlocal reflection operator K とfield radiance operator G により簡略化

L　放射光輝度分布
field radiance operator G はシーン中の各点からの放射光輝度分布をある点r における入射光輝度分布Li(r, ω) に変換
local reflection operator K は点r における入射光輝度分布Li(r, ω) を反射光輝度分布L(r, ω) に変換

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555650529547_image.png)


インバースレンダリングとは、上記の式のLe, K, G をLから推定する問題と言える。ただしLe, K, Gすべて推定するのは困難である。

したがって、いずれかの項目を既知と仮定して推測する。どのパラメーターを推定するかにより、inverse renderingは三種類の典型がある。

**inverse rendering の典型**

|                       | Le        | K         | G         | L  |
| --------------------- | --------- | --------- | --------- | -- |
| inverse lighting      | **未知**    | 既知/部分的に既知 | 既知/部分的に既知 | 既知 |
| inverse reflectometry | 既知/部分的に既知 | **未知**    | 既知/部分的に既知 | 既知 |
| inverse geomety       | 既知/部分的に既知 | 既知/部分的に既知 | **未知**    | 既知 |


shape from shading やphotometric stereo など明るさにもとづく物体の形状推定はinverse geometryに分類される。

このサーベイではinverse geometryは取り扱わず、inverse lightingとinverse reflectometryのみ取り扱う。

## inverse lighting

ある光源は複数光源の線形和で表されるとする。すなわち次のようになる。

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655738525_image.png)


このとき、ある点の輝度$$x_j$$は

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655359210_image.png)

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655439706_image.png)


 $$R_j$$はある基底光源における$$x_j$$の輝度で、$$\alpha_i$$は光源の強さを表す光源分布係数である。
  
inverse lighting とはこのベクトル$$\hat{I}$$を求めることである。
幾何形状Gと反射特性Kが与えられていれば、GIの手法により基底光源ごとの明るさは事前計算可能である。

またG、Kがわからずとも、各基底光源下での実物体の画像があればG、Kの情報を含む明るさが得られる。

**Marshnerらの手法**
ある物体について単光源の方向を変えながら撮影。これをもとに未知光源分布下の光源分布係数を推定。

デメリット
人の顔などの拡散反射成分が多い物体を対象。かつ主に一時反射のみ取扱。これによって係数が安定に求められなかった。

**Hougen らの提言**
CV分野。物体反射特性と光源分布関数の定性的な関係について。
物体が拡散面である場合、光源分布係数の推定が不安定になるのを防ぐために、基底光源数を減らす必要あり。specularの場合は多くの基底光源。


## inverse renderingの周波数解析

凸物体表面における一時反射光に基づく光源推定の安定性を定式化。

凸物体表面上のある点における反射光強度分布は、周波数空間において

$$B_{impq}$$　反射光強度分布を球面調和関数で展開した展開係数
$$L_{lm}$$　光源分布の展開係数
$$\hat{\rho}_{lpq}$$ 　BRDFの展開係数
$$\Lambda_l$$ 　正規化係数
l,m,p,q 球面調和関数の次数


![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555656356352_image.png)


**わからんポイント**


> Ramamoorthi ら[52] が凸物体表面上の1 次反射光にもとづく光源推定の安定性について理論的な解析を報告したのに対し，岡部らは影にもとづく光源推定が経験的にうまく働く理由について周波数領域における理論的解析を報告している[45]．更に彼らは複雑な光源分布を安定かつ効率よく推定するためにHarr Wavelet基底を用いた推定手法を開発している．

TODO:まず周波数空間での表現がわからないのと、このへんの報告をあとで読みたい。



## 明るさの線形性にもとづく光源推定の派生

**光源設計(lighting design)**

- Schnoeneman らはシーンの光源の輝度調整手法　painting with light　を開発

ユーザが指定したシーンの明るさを最も良く再現する　← ？どういうこと

シーン内の幾何形状geometyや反射特性reflectometryが予め手作業などで与えられているとする。

制約つき最小二乗法問題としての定式化


- Costa ら
> 単にユーザが指定したシーンの明るさを最も良く再現するというだけでなく，シーン内のある特定の机面ができるだけ均一に照らされている，ある視点からユーザがシーンを見た場合にまぶしい鏡面反射光が目に入らないといったより複雑な制約条件をも考慮した光源設計法


- Shacked 


> 人間の視知覚特性をも考慮した上で最も良いと思われる光源分布を決定する

TODO:興味深いのであとで読む。

> Shacked, R. and Lischinski, D.:Automatic lighting design using a perceptual quality metric, Computer Graphics Forum (Eurographics 2001), 20(3), pp. 215- 227 (2001).


## 専用のキャリブレーション物体を利用した光源推定

いつもの


- Debevec らは light probe

球と光源までの距離は決まらない。予め手入力で与えられている部屋の形状を利用。

- 神原ら

MRに使うため、小型の球面球を利用した実時間計測・描画システム
TODO:すぐ読む→見つからん
https://ci.nii.ac.jp/naid/10014567874

**ダイナミックレンジ**
これらの手法では、光源分布計測において、specularの反射光強度を正しく求めるために十分広いダイナミックレンジでの計測が必要。
この場合のダイナミックレンジは表現可能な露光の範囲。latitudeと呼ばれることも。


> 写真撮影（露光）において、感光材料に対し適正より少ない露光量（露出アンダー、画像が暗く階調がつぶれるおそれがある）や、反対に適正より多い露光量（露出オーバー、画像が明るく階調が飛ぶおそれがある）であっても階調が無くならず、画像として成立するような特性（露光許容量が大きい）を「ラティチュードが広い」と表現する。このような特性の場合、暗い部分（シャドウ）から明るい部分（ハイライト）までなだらかな階調が再現できる反面、画像がフラット（眠たい調子）になりやすい。
> 
> 反対に、再現できる露光の範囲が狭い特性を「ラティチュードが狭い」と表現する。この場合、露出オーバーやアンダーに対して白とびや黒つぶれを起こしやすいが、メリハリのあるコントラストが高い画像を得ることが出来る。
> https://ja.wikipedia.org/wiki/%E3%83%A9%E3%83%86%E3%82%A3%E3%83%81%E3%83%A5%E3%83%BC%E3%83%89



- Powell

参照球を2つで距離まで推定。ただしいくつかのpoint light のみ。


**キャリブレーション球はspecularだけじゃなくてdiffuse版もある**
十分遠方の一光源でdiffuse球を照らすと、影と明るい部分の円形の境界が観測される。

- Zhangら

diffuse球上でこれらを複数見つけて光源方向と強度推定。
これは明るさの線形性から可能。

- Wangら

Zhangらの手法をもとに任意形状かつノイズの影響を低減。

- Takaiら

二個のdiffuse球から光源の3次元位置まで。
ただし、Powellらと異なり、拡散球上の等輝度線の分布から推定された光源方向をもとに近接光源の位置と強度を求める。

 **デメリット**
 結局境界線や等輝度線を安定に見つけるのが困難。
 数個程度の点光源にしか使えない。
 もちろん近い位置にある光源も無理そう。
 
**影によるキャリブレーション物体**
射影物体の後ろにある影が観察できないのでカメラ側の光源分布推定が困難

**中空の立方体内壁に対するセルフシャドウを利用**
上記問題に対応。無限遠なら安定するが、近接光源だと推定する未知パラメータが極端に多くなるので難しい。



# inverse reflectometry

超訳：ようは各点のBRDFを求めるみたいな感じのやつ


![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1556005923284_image.png)


