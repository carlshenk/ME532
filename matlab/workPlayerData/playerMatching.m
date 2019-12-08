clear all;
close all;

%in this script we will use the player data to cluster players by skill
%type

%import the json files
readData;

%first create skill matrix from data -- rows determine each player
A = zeros(height(playerdata), 2);
for i = 1:height(playerdata)
    A(i,1) = playerdata.skillTags(i).Trivia;
    A(i,2) = playerdata.skillTags(i).Acting;
    A(i,3) = playerdata.skillTags(i).Memory;
    A(i,4) = playerdata.skillTags(i).Deduction;
    A(i,5) = playerdata.skillTags(i).Dexterity;
    A(i,6) = playerdata.skillTags(i).PatternRecognition;
    A(i,7) = playerdata.skillTags(i).Programming;
    A(i,8) = playerdata.skillTags(i).Planning;
    A(i,9) = playerdata.skillTags(i).Luck;
    A(i,10) = playerdata.skillTags(i).Influence;
    A(i,11) = playerdata.skillTags(i).Persuesion;
end

%divide the data into training and validation
Afull = A;
Atrain = A(1:250,:);
Avalid = A(251:end,:);

%now try numerous cluster sizes using kmeans and plot error
sumdv = zeros(1,12);
for i = 1:12
[idxA2,CA2, sumd] = kmeans(Atrain,i);
sumdv(i) = max(sumd);
end

sumdv
%from this we can see that we need 4 clusters. run it again w/ 4 and save
%th ecluster belonging
[idxA2, CA2, sumd] = kmeans(Atrain,4);

Atrain(:,size(Atrain,2)+1) = idxA2;



