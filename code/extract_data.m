%% constants

x_pos = 5; % load data from the middle transect
y_positions = [20, 40, 60, 80, 100, 120];

%% load scenario A data
load('scenarioA_glob_matlab_outputs.mat')

%% get sea level curve and time vector

[sl, t] = get_sl(glob);

%%
wd_mat = zeros(length(t), length(y_positions));
h_mat = zeros(length(t), length(y_positions));
facies_info = {};

%%
for (i = 1:length(y_positions))
    y_pos = y_positions(i);
    [wd, ] = get_wd(x_pos,y_pos , glob);
    wd_mat( :, i) = wd;
    [h, ] = get_adm(x_pos, y_pos, glob);
    h_mat(:, i) = h';
    [th, fa] = get_strat_column(y_pos, x_pos, glob);
    facies_info{i} = {th, fa};
end

%%
save("scenarionA_processed.mat", "t", "sl", "wd_mat", "h_mat", "y_positions", "facies_info")


%% 
function [wd, t] = get_wd(x_pos, y_pos, glob)
    % extracts water depth at a given location from CarboCAT outputs
    % wd: water depth
    % t: time steps
    % x_pos: position parallel to shore
    % y_pos: positon perpendicular to shore
    % glob: glob object produced by CarboCAT
    % outputs:
    % wd: water depth [m]
    % t: time step [1000 y]
    t=(0:glob.totalIterations-1)*glob.deltaT;
    wd = glob.wd(y_pos, x_pos, 1:glob.totalIterations);
    wd = reshape(wd,[1,size(wd,3)]);
    wd(wd<0) = 0;
    t = t(1:glob.totalIterations);
end

function [sl, t] = get_sl(glob)
    % extracts sea level curve from CarboCAT outputs
    % sl: eustatic sea level
    % t: time steps
    sl = glob.SL(1:glob.totalIterations);
    t=(0:glob.totalIterations-1)*glob.deltaT;
end

function [h,t] = get_adm(pos_in_strike_dir, pos_in_dip_dir, glob)
    % extracts age-depth models from CarboCAT model outputs
    % h: vector of heights
    % t: vector of times
    si=size(glob.thickness);
    a1=glob.thickness(pos_in_dip_dir,pos_in_strike_dir,:);
    a2=squeeze(cellfun(@(x) sum(x,'all'),a1));
    h =cumsum([0;a2])';
    t=(0:glob.totalIterations-1)*glob.deltaT;
    h = h(1:length(t));
end

function [out] = get_strat_columns(x_positions, y_positions, glob)
    % extract multiple stratigraphic columns
    % x_positions: vector of grid cell positions perpendicular to shore
    % y_positions: vector of grid cell positions parallel to shore. must be
    % of same length as x_positions. to extract dip sections, use
    % y_postions = repelem( some_pos, length(x_positions))
    % glob: struct returned by CarboCAT 
    % retrurns: a struct with fields x_positions,y_postitions, thickenss,
    % and facies
    out.x_positions = x_positions;
    out.y_positions = y_positions;    
    for ind = 1:length(x_positions)
        x_pos = x_positions(ind);
        y_pos = y_positions(ind);
        [thickness, facies] = get_strat_column(x_pos, y_pos, glob);
        thicknesses{ind} = thickness;
        facies_collection{ind} = facies;
    end    
    out.thickness = thicknesses;
    out.facies = facies_collection;
end

function [thickness, facies] = get_strat_column(x_pos, y_pos, glob)
    % extracts stratigraphic column from CarboCAT outputs 
    % x_pos: position perpendicular to shore
    % y_pos: positon parallel to shore
    % glob: glob object produced by CarboCAT
    % outputs:
    % thickness: thickenss of bed
    % facies: facies of bed
    % note that no of beds is independent of no of time steps
    si = size(glob.thickness);
    tsteps = glob.totalIterations + 1;
    thickness = [];
    facies = [];
    for ( step = 1:tsteps)
        if ( glob.numberOfLayers(x_pos,y_pos,step) ~= 0)
        thickness = [thickness, glob.thickness{x_pos,y_pos,step}];
        facies = [facies, glob.facies{x_pos,y_pos,step}];
        end
    end
end