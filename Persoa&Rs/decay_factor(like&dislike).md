# 衰减函数

Aug 22nd Tue

$${r{uj}} = \frac{{\sum\limits{j \in N(u)}^{} {Sim(j,i){r{ui}}} }}{{\sum\limits{j \in N(u)}^{} {Sim(j,i)} }}$$

$${r_{uj}} = \frac{{\sum\limits_{j \in N(u)}^{} {Sim(j,i){r_{ui}}} }}{{\sum\limits_{j \in N(u)}^{} {Sim(j,i)} }}$$ $${\rm{Preference(}}u,i{\rm{)}} = {r_{ui}} = p_u^T{q_i} = \sum\limits_{f = 1}^F {{p_{u,k}}{q_{i,k}}}$$ $${wight(x,n)}$$

成本越高权重越高 时间越近权重越高 标签权重清零 9

百分点的tag标签公式：

$$wight(x,n)=\frac{1}{1+a{e^{-\frac{x}{a}}}}$$ 且其中， $$x=\sum{{tag_tf_tag_action_tag_attenuation}}$$

$n$ 为每一个品类的决策周期归一化后的决策周期 $a$ 为利用回归进行拟合

一号店意图计算流程

$$ X_{i+1}=\left{ \begin{array}{rcl} {(1-f)}X_i+x_{i+1} & & {x_{i+1}\in{I_{now}}}\

X_i+x_{i+1} & & {x_{i+1}\in{I_{now}}\cap{x_{i+1}=I_{last}}}\ {(1-f)}X_i+0 & & {x_{i+1}\not\in{I_{now}}}

\end{array} \right. $$

遗忘因子：

$$f=k_1({1-{w}})+k_2\frac{t}{T}$$ $$w=\frac{1}{1+e^{(a-bX)}}$$
