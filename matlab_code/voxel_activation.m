
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 賦活領域をボクセル単位で保存する関数
%
% INPUTS.
% change1   : 多重比較補正を行うかどうか選択( FWE|none )
% change2   : 閾値を指定( ex.)0.05 or 0.001 )
% change3   : (1)すべての領域名と確立を保存するか、(2)確立が一番高い領域名と確立を保存するか選択( 1|2 )
% SPM       : 各情報が保存されているmatファイル
% ic        : 対象とするコントラストの番号( コントラストが4つある場合、1～4 )
% Z         : コントラスト作成時に生成され、視覚的な座標情報が保存されているmatファイル( ex.)spmT_0001.mat )
% R         : 視覚的な座標情報とMNI座標が保存されているファイル
% condition : コントラストの種類( ex.)0001 )
% save_dir  : 保存するディレクトリ
% subname   : 被験者名
%
% OUTPUTS.
% Excelファイルに保存(xlsx.)
% ・res_info  : indx_over, t_value, x, y, zの情報
% ・res_label   : 座標に該当する脳領域の選択肢
% ・res_acc : 座標に該当する脳領域の確率
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
subname='mdu191014';
work_dir    = char( fullfile('/Users/kawaratani_yuta/labo/Drive/DATA/brain',subname));
save_dir       = char( fullfile( work_dir));
change1='none'
change2=0.001
change3=2
SPM_path=char( fullfile( work_dir,'HbO','SPM.mat'));
SPM=importdata(SPM_path)
ic=1
Z_path=char( fullfile( work_dir,'HbO','spmT_0001.mat'));
Z=importdata(Z_path)
R_path=char( fullfile( work_dir,'POS.mat'));
R=importdata(R_path)

condition = '0001';         % 保存するコンディションの名前
condition2 = '0002';         % ↓
ic1 = 1;                     % 対象とするコントラストの番号
ic2 = 2;                     % ↓


% 保存するディレクトリを作成
mkdir (char( fullfile( save_dir, condition)) );


for view = 1:6
    
    if ~isempty(Z{view})
        %----------------------------------------------------------------------
        % calculate height thresholds
        thresDesc = change1; % FWEかnoneを選択 spm_input('p value adjustment to control', 1, 'b', 'FWE|none', [], 1);

        df = [SPM.xCon(ic).eidf, SPM.xX.erdf];

        switch thresDesc
            case 'FWE' % Family-wise false positive rate
                %----------------------------------------------------------------------
                u = change2; % 閾値を入力 spm_input('p value (FWE)','+0','r',0.05,1,[0,1]);
                u = spm_uc(u,df, SPM.xCon(ic).STAT , SPM.xVol.R{view},1,SPM.xVol.S{view});

            case 'none' % No adjustment
                %----------------------------------------------------------------------
                u = change2; % 閾値を入力 spm_input(['threshold {',SPM.xCon(ic).STAT,' or p value}'],'+0','r',0.001,1);

                if u <= 1
                    thresDesc = ['p<' num2str(u) ' (unc.)'];
                    u = spm_u(u,df, SPM.xCon(ic).STAT);
                end
        end
        
        indx_over = 0;
        pos_x = 0;
        pos_y = 0;
        pos_z = 0;
        res_tvalue = 0;
        
        
        indx_over = find(Z{view} > u);
        [x_size, y_size] = size(Z{view});
        
        if ~isempty(indx_over)

            x = ceil( indx_over / x_size );
            y = rem(indx_over, x_size);


            %----------------------------------------------------------------------
            % identify (x,y) positions of point 
            x = round(x); y = round(y); 

            % viewは決まっているのでいらない view = get(handles.slider_view, 'value');

            %----------------------------------------------------------------------
            % identify MNI poitions of point 
            xyz = R.rend{view}.xyz; 
            xyz = reshape(xyz, [3 size(R.rend{view}.ren)]);
            
            %res_label，res_infoの初期化
            res_label={length(indx_over)}
            res_acc={length(indx_over)}
           
            for i = 1:length(indx_over)
                % identify MNI poitions of point 
                xyz_p = xyz(:, y(i), x(i)); 
                pos_x(i,1)      = xyz_p(1);
                pos_y(i,1)      = xyz_p(2);
                pos_z(i,1)      = xyz_p(3);

                % identify statistic value 
                res_tvalue(i,1) = Z{view}(y(i),x(i));

                % その場所の領域名と確立を検索する
                [label acc] = nfri_anatomlabel_spm(xyz_p', 'test', 8, 4);
                label = label{1,1};
                acc = acc{1}; 
                nlabel = size(label, 1);

                switch change3
                    case 1
                        % すべての領域・確立を保存する場合 --------------------------
                        xx_label = 'region:';
                        xx_acc   = 'percent:';

                        for j = 1 : nlabel
                            res_label(i, 1) = cellstr(label(j));
                            res_acc(i, 1)   = num2cell(acc(j));
                        end

                    case 2
                        % 確立が一番高い領域のみを保存する場合 --------------------------
                        max_label = 'none';
                        max_acc   = 0;

                        for j = 1 : nlabel 
                            if max_acc < acc(j)
                                max_label = label(j);
                                max_acc   = acc(j);
                            end
                        end
                        
                       
                        res_label(i,1)= cellstr(max_label);
                        res_acc(i,1)   = num2cell(max_acc);

                end

            end 
            


            
            % save ================================================================
            %%% other info. %%%
            % 水平に結合する (indx_over, t_value, x, y, z, label, per)
            res_info         = horzcat(indx_over, res_tvalue);
            res_info         = horzcat(res_info, pos_x);
            res_info         = horzcat(res_info, pos_y);
            res_info         = horzcat(res_info, pos_z);
            res_info         = num2cell(res_info );
            res_info         = horzcat(res_info,res_label,res_acc);
            
            
            
            %%% excelファイルで保存　%%%
            %save_pass = char( fullfile ( save_dir, condition, strcat(sub_name, '_', condition, '_view', num2str(view), '_notactivation.xlsx') ) );
            %save_pass2 = char( fullfile ( save_dir, condition, strcat(sub_name, '_', condition, '_view', num2str(view), '_res_acc.csv') ) );
%save_dir=char(fullfile(work_dir,subname));
%save(char(fullfile(work_dir,strcat(subname,'actived_brain.mat'))),'res_info');

           
            
        end
    end

end
