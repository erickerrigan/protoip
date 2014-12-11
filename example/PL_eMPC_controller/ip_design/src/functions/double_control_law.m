function un = double_control_law(F,G, x, region)

un=cell2mat(F(region))*x'+cell2mat(G(region));