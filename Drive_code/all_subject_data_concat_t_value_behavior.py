import pandas as pd
import numpy as np
import os.path
import matplotlib.pyplot as plt

#namelist=["KK","ta","ys"]
#namelist=["mi","ms","si"]
namelist=["KK","mi","ta","ms","si","ys","KO","yf"]#被験者名
#namelist=["TF","AF","kf","yo"]
#taskname=["Movie"]
taskname=["Drive"]#Task名
when=["pre","post"]#いつか

#fatiguescale=np.array([[18,22],[18,27],[15,23]])
#fatiguescale=np.array([[15,14],[18,22],[21,20],[18,27],[15,23],[21,20]])
#fatiguescale=np.array([[0,1],[0,1],[0,1],[0,1],[0,1],[0,1]])

resist_t_value=np.zeros((20,len(namelist)))

k=0
tyohuku=[]#共通脳領域の格納
accuracylist=[]#正答率格納

prepost_accuracy=[]#パフォーマンス格納
prepost_res=[]
for na in namelist:
    
    
    for ta in taskname:
        
        for time in when:
        
            res=0
            responsetimelist=[]
            responsetime=0
            kk=0
            size=0
            ad=0
            a=0
            las=0
            accuracy=0

            book1=pd.ExcelFile("C:\\Users\\hmatsuoka\\Documents\\MISL\\Mentalfatigue\\"+ta+"\\"+na+"\\"+time+"\\"+na+"_"+time+"_"+ta+".xlsx")#fileよみこみ
            sheet=book1.parse("Sheet1")
            code=sheet["Code"]#刺激名を抜出(green,yellow,red)
            itu=sheet["Time"]#時系列の抜出
            Ttime=sheet["TTime"]#刺激に対するresponse抜出
            
            for i,j in enumerate(code):
                    if j=="task":
                        a=itu[i]-itu[0]
                        #print(itu[i]-itu[0]+prelast)
                    #if j=="rest":
                        
                        #print(itu[i]-itu[0]-a)
                    if j=="red":
                        if code[i+1]==1:#res stimに反応していたらカウント
                            accuracy=accuracy+1
                    if j=="green":#green stimに反応したら，反応時間をカウント
                            responsetime=responsetime+Ttime[i+1]
                            responsetimelist.append(Ttime[i+1])
                            size=size+1
                            if code[i+1]==1:
                                kk=kk+1
                        
                    if j=="yellow":#yellow stimに反応したら，反応時間をカウント
                            responsetime=responsetime+Ttime[i+1]
                            responsetimelist.append(Ttime[i+1])
                            size=size+1
                            if code[i+1]==1:
                                kk=kk+1
            res=(sum(responsetimelist)/len(responsetimelist))/10
            
            if time=="pre":
                prepost_accuracy.append((  (  (1- (accuracy/40) )  *100)  /res))#40刺激あるので，間違えた数を%にして反応時間で除算＝パフォーマンス
                accuracylist.append((1- (accuracy/40) )  *100)
                prepost_res.append(res)
            if time=="post":
                prepost_accuracy.append((  (  (1- (accuracy/40) )  *100)  /res))
                accuracylist.append((1- (accuracy/40) )  *100)
                prepost_res.append(res)
            
        
for task in taskname:
    for name in namelist:
        sheet=pd.read_excel("C:\\Users\\hmatsuoka\\Documents\\MISL\\Mentalfatigue\\"+task+"\\"+name+"\\"+"result_t_value_notactivation.xlsx",sheet_name='Sheet1',header=None,index=None)
        pre_t_value=sheet.ix[:,1]
        post_t_value=sheet.ix[:,5]
        tyohuku.append(sheet.ix[:,0].values.tolist())
        tyohuku.append(sheet.ix[:,4].values.tolist())


result=pd.DataFrame()
for ind in tyohuku:#全被験者で共通している脳領域の抜出し
    tyohuku[0] = list(set(tyohuku[0]) & set(ind))
aal=(tyohuku[0])
print(aal)

for name in namelist:
    for task in taskname:
        result_data_pre=pd.DataFrame()
        result_data_post=pd.DataFrame()
        for i in aal:#共通脳領域の数回す
            
            sheet=pd.read_excel("C:\\Users\\hmatsuoka\\Documents\\MISL\\Mentalfatigue\\"+task+"\\"+name+"\\"+"result_t_value_notactivation.xlsx",sheet_name='Sheet1',header=None,index=None)
            for number,data in enumerate(sheet.ix[:,0]):
                if i == data:#共通脳領域と一致する部分を抜き出す
                    
                    #Main task前の1被験者の共通脳領域を縦方向にconcatする
                    result_data_pre=pd.concat([result_data_pre,pd.Series(sheet.ix[number,1])],axis=0)

            for number,data in enumerate(sheet.ix[:,4]):
                
                if i == data:#共通脳領域と一致する部分を抜き出す
                
                    #Main task後の1被験者の共通脳領域を縦方向にconcatする
                    result_data_post=pd.concat([result_data_post,pd.Series(sheet.ix[number,5])],axis=0)

            
    #各被験者のMaintask前後が横方向に並ぶ
    #例）KK-pre KK-post mi-pre mi-post ...
    result=pd.concat([result,result_data_pre,result_data_post],axis=1)


accuracylist=pd.Series(accuracylist)#正答率の配列
prepost_accuracy=pd.Series(prepost_accuracy)#パフォーマンス結果
prepost_res=pd.Series(prepost_res)#反応時間（ｍｓ）
prepost_accuracy=pd.concat([prepost_accuracy,accuracylist,prepost_res],axis=1)#パフォーマンス，正答率，反応時間の順でconcat
result.columns=[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15] #にんずうが増えたり変わったしたらここかえなあかん
result.index=aal#indexとして各脳領域を設定
result=pd.concat([result,prepost_accuracy])
result.to_excel("C:\\Users\\hmatsuoka\\Documents\\MISL\\Mentalfatigue\\"+taskname[0]+"\\"+"result_t_valuet_resist.xlsx",sheet_name='Sheet1',header=None)#各共通脳領域のt値をはきだす
prepost_accuracy.to_excel("C:\\Users\\hmatsuoka\\Documents\\MISL\\Mentalfatigue\\"+taskname[0]+"\\"+"result_t_valuet_accuracy.xlsx",sheet_name='Sheet1',header=None,index=None)#各被験者のGo/NoGo結果をはきだし
