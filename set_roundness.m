function design = set_roundness(design, data,params)

        x = design.mat{params.iblock}(:,5); 
        y = abs(data.mat{params.iblock}(:,5));
        fit_1 = robustfit(x,y,'ols'); 
        a = fit_1(2); 
        b = fit_1(1); 
        design.roundness(1) = (design.target_SDerror(params.index)/design.mean_mult-b)/a;

end