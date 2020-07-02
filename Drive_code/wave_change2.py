import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import pickle
import math




if __name__ == "__main__":
    # 波長データで帰ってきてル時
    namelist = ["mta191010", "myf191010", "mtw191014", "mto191014","mdu191014","msj191015"];
    for name1 in namelist:
        logfile = pd.read_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/" + name1 + "_oeg.csv")
        co = 0
        OxyHb = []
        deoxyHb = []
        for columnname, item in logfile.iteritems():
            co += 1
            if co < 17:
                OxyHb.append(item)
            else:
                deoxyHb.append(item)
        # print(OxyHb)
        OxyHb = np.array(OxyHb)
        deoxyHb = np.array(deoxyHb)
        wave1_df = pd.DataFrame(OxyHb).T
        wave2_df = pd.DataFrame(deoxyHb).T

        wave1_df.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/" + name1 + "_oeg_wave1.csv",header=None, index=None)
        wave2_df.to_csv("/Users/kawaratani_yuta/labo/Drive/DATA/brain/" + name1 + "/" + name1 + "_oeg_wave2.csv",header=None, index=None)
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

