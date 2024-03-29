fname = 'ECE532GameData.json';
fid = fopen(fname);
raw = fread(fid, inf);
str = char(raw');
fclose(fid);
gamedata = struct2table(jsondecode(str));

fname = 'ECE532PlayerData2.json';
fid = fopen(fname);
raw = fread(fid, inf);
str = char(raw');
fclose(fid);
playerdata = struct2table(jsondecode(str));

game_cat_names = {'complexity', 'depth', 'speed', 'thematic', 'interaction', 'players', 'mass', 'obscurity'};
games = zeros(length(game_cat_names),height(gamedata));
for i = 1:length(game_cat_names);
    eval(['games(' num2str(i) ',:) = [gamedata.primaryCategories(:).' game_cat_names{i} '];']);
end
games = games';


%now make user category names 

base_names = {'complexity', 'depth', 'speed', 'thematic', 'interaction', 'players', 'mass', 'obscurity'};
user_cat_names = cell(length(base_names)*5, 1);
k = 1;
for i = 1:length(base_names)
for j = 1:5
   name =  [base_names{i} num2str(j) 'C'];
    user_cat_names{k} = name;
    k=k+1;
end
end



userTags = zeros(length(user_cat_names),height(playerdata))';
for i = 1:length(user_cat_names);
    eval(['userTags(:,' num2str(i) ') = playerdata.' user_cat_names{i} ';']);
end

user_comb_stats = zeros(height(playerdata), length(base_names));
for i = 1:length(base_names)
   user_comb_stats(:,i) = mean(userTags(:,(i-1)*5+1:(i-1)*5+5), 2); 
    
end

%now do tags -- this will get all the field names. now just need to combine
%them all
tag_field_names = {'competitionTags', 'mechanicTags', 'settingTags', 'uncertaintyTags', 'interactionTags', 'atmosphereTags', 'skillTags'};
field_sizes = [];
all_user_tag = {};
for i = 1:length(tag_field_names)
    tagfield = tag_field_names{i};
    eval(['temp_tag = fields(playerdata.' tagfield ');']);
    all_user_tag = {all_user_tag{:}, temp_tag{:}};
    field_sizes(i) = length(temp_tag);
end


%competition tag
users = zeros(length(all_user_tag),height(playerdata));
dt = 1;
tagiter = 1;
maxcnt = field_sizes(tagiter);
for i = 1:length(all_user_tag);
   if(dt > maxcnt)
      %advance tag name counter
      dt = 1;
      tagiter = tagiter+1;
      maxcnt = field_sizes(tagiter);
   end
   dt=dt+1;
    tag_name = tag_field_names{tagiter};
    cat_name = all_user_tag{i};
    
    eval(['users(' num2str(i) ',:) = [playerdata.' tag_name '(:).' cat_name '];']);
end
users = users';

%now combine users matrices
users_c = [users userTags]; %should be 500x109

%now create some data correlating which people like which game
%1,1 is player 1 liking game 1. 1,2 is player 1 liking game 2 -- columns
%correspond to games
likeMatrix = zeros(length(users_c), length(games));
% like_th = .2;
for i = 1:length(games)
    est_like = sum(((games(i,:)-user_comb_stats).^2).*rand(length(users_c), 1), 2);
    likeMatrix(:,i) = est_like;
end

%now randomly decimate this matrix
if(~exist('rating_density', 'var'))
    rating_density = .1;
end
mask = sprand(length(users_c), length(games), rating_density);
mask = mask > 0;
likeMatrix = likeMatrix.*mask;

% sum(sum(likeMatrix > 0))/(500*500);


