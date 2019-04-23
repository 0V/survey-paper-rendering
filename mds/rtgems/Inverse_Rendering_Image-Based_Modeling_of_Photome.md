# Inverse Rendering: Image-Based Modeling of Photometric Aspects インバースレンダリング：画像からの光学情報の復元


# Cite

2005年

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

## image-based rendering 何に使うの？

視点位置変更


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

|                       | Le （光源）   | K （反射特性）  | G （幾何形状）  | L  |
| --------------------- | --------- | --------- | --------- | -- |
| inverse lighting      | **未知**    | 既知/部分的に既知 | 既知/部分的に既知 | 既知 |
| inverse reflectometry | 既知/部分的に既知 | **未知**    | 既知/部分的に既知 | 既知 |
| inverse geomety       | 既知/部分的に既知 | 既知/部分的に既知 | **未知**    | 既知 |


shape from shading やphotometric stereo など明るさにもとづく物体の形状推定はinverse geometryに分類される。

このサーベイではinverse geometryは取り扱わず、inverse lightingとinverse reflectometryのみ取り扱う。

## inverse lighting

**要請**
明るさの線形性を仮定。複数の光源が存在する環境において観察される物体の明るさは、それぞれの光源の下における物体の明るさの和に等しい。

ある光源は基底光源の線形和で表されるとする。すなわち次のようになる。

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655738525_image.png)


このとき、ある点の輝度$$x_j$$は

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655359210_image.png)

![](https://paper-attachments.dropbox.com/s_9CB710F8DE5213574B2D2442B1BE7CE3784790B4226DCF77A249F43F1ED52A9B_1555655439706_image.png)


 $$R_j$$はある基底光源における$$x_j$$の輝度で、$$\alpha_i$$は光源の強さを表す光源分布係数である。
  
inverse lighting とはこのベクトル$$\hat{I}$$を求めることである。
**幾何形状Gと反射特性Kが与えられていれば、GIの手法により基底光源ごとの明るさは事前計算可能である。**

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


[+Inverse Rendering: Image-Based Modeling of Photometric Aspects インバースレンダリング：画像からの光学情報の復元: inverse-renderingの周波数解析](https://paper.dropbox.com/doc/Inverse-Rendering-Image-Based-Modeling-of-Photometric-Aspects-inverse-rendering-sDoR6rHeL25CNnvw23SAj#:uid=036417129934241473711488&amp;h2=inverse-rendering%E3%81%AE%E5%91%A8%E6%B3%A2%E6%95%B0%E8%A7%A3%E6%9E%90) 


## 問題

inverse lighting と同様に、高周波成分を持たない光源分布Lの下で観察された画像ではBRDFの展
開係数の低次項しか安定に求められない。暗い環境での単一point lightを取り扱う理由はこれ。


## 必要要素

光の入射方向、視線方向を変化させたときの反射光強度変化が必要

**どうやって得るか**
光源方向（θ、Φ）、視線方向（θ’、Φ’）の４自由度を変化させて反射光強度計測が必要。
実世界ではゴニオフォトメータが用いられるが、もちろん時間がかかる。
inverse renderingではisotropic（等方的）な反射を仮定して、自由度をひとつ（この場合はΦ）を消す。

実世界での計測では、、移動もしくは固定された光源に対し物体の姿勢を変えながら計測する手法も取られる。
また、対象物体の反射特性が均一として、物体表面上の各点で異なる入射方向、反射方向に対する反射光強度をまとめて計測することもされる。Marschner らのimage-based BRDF measurementがこれ。


## 1次反射光を用いた反射特性の推定

**よく用いられるモデルの種類**

- Lambert model
- Phong reflection model
- Cook-Torrance reflection model
- Torrance-Sparrow reflection model (以下TS reflection model)

パラメタが少ないパラメトリック反射関数モデル



## パラメトリック反射関数モデルを使う手法

Lambertian以外の場合を見る

~~ **レンジセンサなどによって別途計測された3 次元形状を利用する手法 ~~** 

**ここから無限遠、単光源**


- Ikeuchiら

物体表面が均一反射特性を持つと仮定
一組の距離画像（range image）と濃淡画像（gray-scale image）からTS reflection modelのパラメタ推定
物体表面のreflection model パラメタに加え単光源方向も推定


- Kay ら

一枚のrange imageと異なる光源方向をもつ４枚のgray-scale image から均一でない反射特性を持つ物体について推定。Ikeuchiらと同じく面法線方向を推定後、gray-scale imageから各点のTS reflection model のパラメタを非線形最適化で得る。


- 大槻ら

非均一推定。
既知の場所に単光源をおき、物体を回転させながら形状情報とカラー画像列を取得。物体表面各点で簡略化したCook-Torrance reflecttion modelのパラメタを推定。specularの成分が一部でしか観測されないために、その一部だけspecular成分を推定。


- Sato ら

鏡面反射光が光源と同一色であることを利用。diffuse成分とspecular成分を分離。diffuse成分の色にもとづき領域分割。各領域で均一なspecular反射特性をもつとしてTS reflection modelの推定。
のちに拡張され、specular反射特性を得るのに適した場所を推定。それらを全体で補間して全体のspecular反射特性を推定できるように。

**ここから無限遠、複数光源**


- Nishinoら

上記と違い複数光源。
異なる方向から反射光を観測した場合、鏡面反射成分の強度のみが変動することをもちいて分離。

**ここから近接光源**

- 基本手順

平面物体を撮影した透視投影画像をもとに、specularとdiffuseの偏光状態の違いをもとに分離。分離されたspecular成分に、対数変換で線形になったTS reflection modelを考慮することで、光源位置とspecularパラメタを推定。


-  原ら

色に基づくreflection成分分離で一枚入力画像から近接光源位置と反射パラメタ推定できるように拡張。


- Lenschら

比較的少数の入力画像から物体表面上で変化するreflection model のパラメタを推定。
Satoらの色による分離と違い、反射関数のパラメタ空間でクラスタリングすることで表面を分割。
反射特性の微妙な変化表現のために、各クラスタで基底反射関数を求め、これらの線形結合で各点反射特性を表現。
**少ない枚数の入力画像のみをから非常に現実感の高い合成画像** 


**問題**
局所的な情報のみ扱うので大域的な反射光のばらつきが表現できない。
したがってザラザラした表面上の鏡面反射がうまく表現できない。


- 馬場ら

マイクロファセットレベルでの面方向のばらつきと、中間レベルの面のばらつき表現のためにTS reflection modelからの誤差を生じさせるバンプモデルを導入。

[+バンプモデルを用いた実物体の反射特性のモデル化とパラメータ推定](https://paper.dropbox.com/doc/LdcaxcATpISQMgbqNyWEV) 


 **~~ 画像のみから推定する手法 ~~**  

- Tominagaら

一枚のカラー画像。

予め幾何形状が与えられている場合
2 色性反射モデルにもとづく色解析により反射成分を分離。鏡面反射光の強度が最大の点と半減する点との面法線からPhong reflection modelを推定する．

形状が未知の物体の場合
分離された拡散反射成分の明るさに対してshape from shading（形状推定）により面法線を推定している。
制約として、不均一な反射特性を持つ物体には適用できない。




## パラメトリック反射関数を仮定しない手法

BRDF そのものを画像から計測する

**問題**
BRDFの自由度は４（入射方向、反射方向）
法線に関して回転対称な反射特性を仮定すれば３自由度になる。（isotropicなBRDF）
しかし画像のみからは難しい。


- Marschnerら  

表面全体で均一な反射特性を仮定することでさまざまな入射方向・反射方向での反射光強度を計測し、情報を増やす。**image-based BRDF measurement** と呼ばれる。
幾何と光学のキャリブレーションによりBRDFを精度良く得られた。


- 西山ら

大理石のようにテクスチャを持った物体も対象。
２自由度の反射分布関数を用いる。（一般のBRDFは４自由度）
反射分布関数をクラスタリングしておき、各クラスごとに分布関数テーブルを作成。
物体表面上のクラス分布をマルコフモデルによって学習した。



