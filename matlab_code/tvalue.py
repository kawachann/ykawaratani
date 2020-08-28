import numpy as np
import statsmodels.api as sm
import pandas as pd
from matplotlib import pyplot as plt
import os.path

def zscore(x, axis = None): #z変換の関数
    xmean = x.mean(axis=axis, keepdims=True)
    xstd  = np.std(x, axis=axis, keepdims=True)
    zscore = (x-xmean)/xstd
    return zscore

namelist=["test3"]
#nback=["1back","2back","3back"]
viewlist=["1","2","3","4","5","6"]

for name in namelist:

    #for n in nback:

        result_value=pd.DataFrame()
        resistname=[]
        t_valuedf=pd.DataFrame()

        resistdf=pd.DataFrame()

        for view in viewlist:
            dir = os.path.exists("/Users/wataru/Desktop/Tvalue_csv/" + name + "_0001_" + "view" + view + "_notactivation.xlsx")
            if dir == True:
                #for n in nback:

                sheet=pd.read_excel("/Users/wataru/Desktop/Tvalue_csv/"+name+"_0001_"+"view"+view+"_notactivation.xlsx",'Sheet1',header=None,index=None)
                t_value=sheet.ix[:,1]#全ボクセルt値
                t_valuedf=pd.concat([t_valuedf,t_value],axis=0)#t値だけdf
                resist=sheet.ix[:,5]#
                resistdf=pd.concat([resistdf,resist],axis=0)#領域だけdf
                resname=resist.values.tolist()#領域だけlist型

                resname=list(dict.fromkeys(resname))##被ってる領域をまとめる

                for i in resname:##
                    resistname.append(i)##まとめた領域をlistで並べていく

        if t_valuedf.empty == False: #t値が入ってれば
            t_value=np.array(t_valuedf) #t値dfをnumpy型に
            z_score = zscore(t_value) #全ボクセルt値をzscoreに

            z_score=z_score[:,0].tolist() #zscoreの全行をlist型に

            #resistname=list(dict.fromkeys(resistname))
            #print(resistname)
            resistdf = resistdf.ix[:,0].values.tolist() #領域dfをlist型に
            #print(z_score)


            res_max = []
            res_min = []
            res_ave = []
            for res in resistname: #res=まとめた領域の数
                t_value=[z_score[i] for i,do in enumerate(resistdf) if do == res]
                #print(t_value)
                res_max.append(max(t_value)) #t値の最大値を領域ごとに並べる
                res_min.append(min(t_value)) #min
                res_ave.append(sum(t_value)/len(t_value)) #平均

            #print(t_value)
            res_max = pd.Series(res_max) #最大値をSeriesに
            res_min = pd.Series(res_min) #最小値をSeriesに
            res_ave = pd.Series(res_ave) #平均値をSeriesに
            resname = pd.Series(resistname) #まとめた領域をSeriesに
            result=pd.concat([res_max,res_min,res_ave],axis=1) #max，min，aveを行で結合
            result_value=pd.concat([resname,result],axis=1) #領域と結合

            result_value.to_excel("/Users/wataru/Desktop/Tvalue_csv/"+name+"_"+"_result_t_value.xlsx") #xlsxに掃き出す




