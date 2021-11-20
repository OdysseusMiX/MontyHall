function p = threeDoorsProblem(strategy)
% Evaluate the probability of winning a car with the given strategy
%
% STRATEGY may be either 'stay', 'switch', or 'flip coin'. If no strategy
% is specified, 'switch' will be used.
% 
% The function will return the empirical probability of winnning after
% evaluating 1 million games.
%
% The Monty Hall Problem is a famous statistics paradox that is based on a
% fictional version of the game show, Let's Make a Deal. In the fictional
% scenario, the contestant is asked to choose one of three doors. Behind
% one of the doors is a brand new car, but behind the other two doors are
% goats (i.e. no prize). After choosing a door, the host, Monty Hall, will
% open a door that the contestent did not choose and does not contain the
% car. Now that only two doors remain, Monty Hall will ask the contestant
% if they would like to keep their chosen door, or switch to the other
% closed door.
%
% The question is: Are you likelier to win the car if you always switch or
% stay, or does it not matter?
%
% Answer: Although it seems like a 50/50 chance, you can increase your odds
% of winning to 2/3 if you always switch. Always staying will win 1/3 of
% the time. Interestingly, if you were undecided and flipped a coin to
% randomly make your decision, you odds become 50/50.

% Created by Michael Heinz, 20 Nov 2021

nGames = 1e6;

% select game strategy
if nargin<1
    strategy = 'switch';
end
doYouSwitchDoors = processInput(strategy);

% preallocate results array to speed up processing
didWin = false(1,nGames);

% setup game and contestent choice for each game using random numbers
winningDoor = chooseDoor(nGames);
chosenDoor = chooseDoor(nGames);

% conduct each game using the specified strategy
for i = 1:nGames
    didSwitch = doYouSwitchDoors();
    if didSwitch
        didWin(i) = winningDoor(i) ~= chosenDoor(i);
    else
        didWin(i) = winningDoor(i) == chosenDoor(i);
    end
end

% evaluate probability of winning (successes / number of trials)
p = sum(didWin)/nGames;

function functionHandle = processInput(strategy)
switch lower(strategy)
    case 'stay'
        functionHandle = @alwaysStay;
    case 'switch'
        functionHandle = @alwaysSwitch;
    case 'flip coin'
        functionHandle = @coinFlip;
    otherwise
        error('Input must be either ''stay'', ''switch'' or ''flip coin''');
end

function choices = chooseDoor(nTrials)
randomNumbers = rand(1,nTrials);
choices = zeros(1,nTrials);
choices(randomNumbers <= 1/3) = 1;
choices(randomNumbers > 2/3) = 3;
choices(choices == 0) = 2;

function tf = alwaysStay
tf = false;

function tf = alwaysSwitch
tf = true;

function tf = coinFlip
tf = rand(1) > 0.5;