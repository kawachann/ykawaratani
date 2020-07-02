"""
前処理をすべて行う　最終確認4/17
"""

import pandas as pd
import numpy as np

#namelist=["AF","kf","mh","st","TF","yo",'ao','sy','mg','rn']#被験者名
#namelist=["KK","yf","si","ta","KO","rsf","to","ys","mi","ms","kkb4","tob4"]
#namelist=["kkb4","tob4"]
#namelist=['sy','mg','rn']
namelist=["KO"]
tasklist=["Drive"]#task名
whattask=["pre","post"]


#---------------------------測定データやfastrackのデータをspm-fnirsのデータにする------------------------------------------------------------
for name in namelist:
    for task in tasklist:
        book=pd.read_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+name+"_"+task+"_origin.csv",header=None)
        book2=pd.read_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+name+"_"+task+"_others1.csv",header=None)
        book[0][0]="Reference"
        print(book)
#----------------------------位置情報のデータを作成する--------------------------------
        othersdata=pd.DataFrame()
        probedata=np.zeros((12,3))
        s=[]
        d=[]
        Sprobeindex=[]
        Dprobeindex=[]
        df=pd.Series(["S1","S2","S3","S4","S5","S6","D1","D2","D3","D4","D5","D6"])
        othersdata=book2.ix[0:11,1:3]
        #othersの各プローブ情報を抜出し
        probe=[1,2,3,4,5,6]
        #プローブ数
        k=0
        for i,banme in enumerate(probe):
            probedata[i,0]=othersdata.ix[k,1]
            probedata[i,1]=othersdata.ix[k,2]
            probedata[i,2]=othersdata.ix[k,3]
            probedata[i+6,0]=othersdata.ix[k+1,1]
            probedata[i+6,1]=othersdata.ix[k+1,2]
            probedata[i+6,2]=othersdata.ix[k+1,3]
            k=k+2

        probedata=pd.DataFrame(probedata)
        df=pd.concat([df,probedata],axis=1)
        df.columns=["Optode","X","Y","Z"]
        book.to_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\result\\"+name+"_"+task+"_origin.csv",header=None,index=None)

        df.to_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\result\\"+name+"_"+task+"_optode.csv",index=None)
        
#----------------------------wave1,wave2のデータを作成する--------------------------------
        
        pretask= pd.read_excel("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+task+"\\"+name+"\\"+name+"_post_"+task+"_oeg.xlsx", sheet_name="Sheet1",header = None)

        prewave1 = pretask.ix[:,[0,12,2,14,16,26,28,40,30,42,44,54,56,68,58,70]]
        prewave2 = pretask.ix[:,[1,13,3,15,17,27,29,41,31,43,45,55,57,69,59,71]]
        postwave1 = posttask.ix[:,[0,12,2,14,16,26,28,40,30,42,44,54,56,68,58,70]]
        postwave2 = posttask.ix[:,[1,13,3,15,17,27,29,41,31,43,45,55,57,69,59,71]]
        #prewave1.to_csv("C:\\Users\\USER\\Documents\\MISL\\Mentalfatigue\\"+task+"\\"+name+"\\"+"pre\\"+name+"_"+task+"_pre_wave1.csv",header = False,index=False)
        #prewave2.to_csv("C:\\Users\\USER\\Documents\\MISL\\Mentalfatigue\\"+task+"\\"+name+"\\"+"pre\\"+name+"_"+task+"_pre_wave2.csv",header = False,index=False)
        postwave1.to_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+task+"\\"+name+"\\"+"post\\"+name+"_"+task+"_post_wave1.csv",header = False,index=False)
        postwave2.to_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+task+"\\"+name+"\\"+"post\\"+name+"_"+task+"_post_wave2.csv",header = False,index=False)

#--------------------------------------------------------------------------------------------------------------------------ここまで




#------------------------------------------------バッチファイルを回すために，タスクの始まりやDurationをcsvに--------------------------------------------------------------------       
        for time in whattask:

            tasktime_start=pd.DataFrame()
            tasktime_duration=pd.DataFrame()
            starttime=[]
            durationtime=[]
            responsetimelist=[]
            responsetime=0
            

            book1=pd.ExcelFile("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\"+name+"_post_"+task+".xlsx")
            sheet=book1.parse("Sheet1")
            code=sheet["Code"]
            itu=sheet["Time"]
            Ttime=sheet["TTime"]
            duration=sheet["Duration"]
            a=0

            for ituka,j in enumerate(code):
                if j=="rest":
                    if a>0:
                            
                        durationtime.append((itu[ituka]-taskstart)/10000)
                        #rest開始時間から前のタスク終了時間を引いてDurationを算出
                            
                        #print("rest")
                        #print((itu[i]-itu[0])/10000)
                    a=a+1
                        
                        
                if j=="task":
                        
                    starttime.append((itu[ituka]-itu[0])/10000)
                    #task開始時間に対しpresentartionの刺激提示時間を引くことでonset計算
                    taskstart=itu[ituka]
            st=pd.Series(starttime)
            dt=pd.Series(durationtime)
            tasktime_start=pd.concat([tasktime_start,st,dt],axis=1)
                
            tasktime_start.to_csv("C:\\Users\\kawaratani_yuta\\labo\\Drive\\matuoka_data\\result\\"+name+"_post_"+task+"_taskstarttime.csv",header=False,index=False)
