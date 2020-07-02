

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import math
subject=list(range(2,12))

def wave2(OxyHb,deoxyHb):
    O2=(89707.36*OxyHb+692.36*89707.36*deoxyHb)/(692.36*1022-1311.88*650)
    return (O2/10000)
def wave1(deoxyHb,O2):
    O1=(1/650)*(1022*O2-(1311.88*1022-692.36*650)*deoxyHb)
    return (O1/10000)

if __name__=="__main__":
    #波長データで帰ってきてない時
    V10=33980
    V20=35336
    namelist=["mkt191007","mkk191007","mnt191005","myo191005"];
    for name1 in namelist:
        logfile=pd.read_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/"+name1+"_oeg.csv",header=None)
        co=0
        OxyHb=[]
        deoxyHb=[]
        for columnname,item in logfile.iteritems():

            if co<16:
                OxyHb.append(item)
            else:
                deoxyHb.append(item)
            co += 1
        OxyHb=np.array(OxyHb)
        deoxyHb=np.array(deoxyHb)
        ch_ramda1=[]
        ch_ramda2=[]

        for i, Oxy in enumerate(OxyHb):
            ramda1_list=[]
            ramda2_list=[]
            print(i)
            for j ,data in enumerate(Oxy):


                O2=wave2(data,deoxyHb[i,j])
                O1=wave1(deoxyHb[i,j],O2)
                ramda1=V10/(10**(O1))
                ramda2=V20/(10**(O2))
                #ramda1=V10**(-10)
                #ramda2=10**(-1*O2)*V20
                ramda1_list.append(ramda1)
                ramda2_list.append(ramda2)
            ch_ramda1.append(ramda1_list)
            ch_ramda2.append(ramda2_list)
        wave1_df=pd.DataFrame(ch_ramda1).T
        wave2_df=pd.DataFrame(ch_ramda2).T

        wave1_df.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/"+name1+"_oeg_wave1.csv",header=None,index=None)
        wave2_df.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/"+name1+"_oeg_wave2.csv",header=None,index=None)



for name in namelist:
        book = pd.read_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name + "/FL/" + name + "_origin.csv", header=None)
        book2 = pd.read_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name + "/FL/" + name + "_others1.csv", header=None)
        book[0][0] = "Reference"
        print(book)
        # ----------------------------位置情報のデータを作成する--------------------------------
        othersdata = pd.DataFrame()
        probedata = np.zeros((12, 3))
        s = []
        d = []
        Sprobeindex = []
        Dprobeindex = []
        df = pd.Series(["S1", "S2", "S3", "S4", "S5", "S6", "D1", "D2", "D3", "D4", "D5", "D6"])
        othersdata = book2.ix[0:11, 1:3]
        # othersの各プローブ情報を抜出し
        probe = [1, 2, 3, 4, 5, 6]
        # プローブ数
        k = 0
        for i, banme in enumerate(probe):
            probedata[i, 0] = othersdata.ix[k, 1]
            probedata[i, 1] = othersdata.ix[k, 2]
            probedata[i, 2] = othersdata.ix[k, 3]
            probedata[i + 6, 0] = othersdata.ix[k + 1, 1]
            probedata[i + 6, 1] = othersdata.ix[k + 1, 2]
            probedata[i + 6, 2] = othersdata.ix[k + 1, 3]
            k = k + 2

        probedata = pd.DataFrame(probedata)
        df = pd.concat([df, probedata], axis=1)
        df.columns = ["Optode", "X", "Y", "Z"]
        book.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name + "/" + name + "_new_origin.csv",header=None, index=None)

        df.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name + "/" + name + "_optode.csv",index=None)



