function [WCCN] = wccn_warper(finalDevIVs, spk_labs)
[~,~,J]=unique(spk_labs);
[WCCN, ~] = wccn(finalDevIVs',J');   