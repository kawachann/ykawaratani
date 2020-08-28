function region_str = make_sub_region2(tbl, probe)
    num_of_det = 2*size(probe.detPos, 1);
    num_of_src = 2*size(probe.srcPos, 1);
    Reference_point = ["a1", "a2", "cz", "iz", "nas"];
    num_of_Ref_point = size(find(ismember(tbl.Name, Reference_point)), 1);
    num_of_conn = size(tbl, 1)-num_of_det-num_of_src-num_of_Ref_point;
    conn_ind = zeros(num_of_conn, 1);
    for i = 1:num_of_conn
        tbl_row = i+num_of_det+num_of_Ref_point;
        current_region = cell2mat(tbl.region(tbl_row));
        if ~strcmp(current_region(1:2), 'ba') && tbl.depth(tbl_row)<30
            conn_ind(i, 1) = 1;
        end
    end
    ind_first = zeros(num_of_det+num_of_Ref_point, 1);
    ind_later = zeros(num_of_src, 1);
    ind  = [ind_first; conn_ind; ind_later];
    region_cell = tbl.region(logical(ind));
    region_str = string(region_cell);
end