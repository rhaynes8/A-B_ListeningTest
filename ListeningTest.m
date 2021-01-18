clear all
clc
format short
pause on

% Build track selection matrix (3 X 3) of ambisonic order and room size as follows: 
%------------------------------------------------------------------------
% Ambisonic Order         Small Room     Medium Room (2000)    Large Room     
%------------------------------------------------------------------------
% First Order               1OS                 1OM               1OL        
% Second Order              2OS                 2OM               2OL      
% Third Order               3OS                 3OM               3OL      
%------------------------------------------------------------------------

S = 1:7; % Choose storage array for string lengths = file name lengths
T = 8:14;
U = 15:21;
M(1,S) = '1OS.wav';
M(1,T) = '2OS.wav'; 
M(1,U) = '3OS.wav';

M(2,S) = '1OM.wav';
M(2,T) = '2OM.wav';
M(2,U) = '3OM.wav';

M(3,S) = '1OL.wav';
M(3,T) = '2OL.wav';
M(3,U) = '3OL.wav';

% Create actual play vs. choice play(ed) matrices
P(3,3) = 0; % "A matrix to record the subject's perception result"
K(3,3) = 0; % "A Matrix to record the true result



% Print initial instructions in a clear way in the command window before
% starting
initialInstructions = 'In this listening test, it is trying to be determined whether varying types of reverberation in rooms have a significant';
initialInstructions = [initialInstructions newline newline 'impact on the perception of using 1st, 2nd and 3rd order ambisonics in binaural rendering.'];
initialInstructions = [initialInstructions newline newline 'There are nine ABX tests in total. Each test consists of two binaural renders (A and B tests) using two different ambisonic orders for encoding.'];
initialInstructions = [initialInstructions newline newline 'A third binaural render (X test) will be played in each test which has an unknown ambisonic order, but will be an exact duplicate of either of the previous two orders heard.'];
initialInstructions = [initialInstructions newline newline 'You will be asked which of the previous two renders (A or B) is identical to the third, mystery render (X).'];
initialInstructions = [initialInstructions newline newline 'Tests 1-3 will take place in a small room, tests 4-6 in a medium room, and tests 7-9 in a large room. '];
initialInstructions = [initialInstructions newline newline 'PLEASE READ ALL ON-SCREEN INSTRUCTIONS CAREFULLY BEFORE PROGRESSING'];
initialInstructions = [initialInstructions newline]; 
fprintf(initialInstructions);

% Read in the sample audio files under practice variable names
[u,~] = audioread(char(M(1, S))); % FOA Small/Med/Large
[w,fs] = audioread(char(M(3, U))); % 3OA Small/Med/Large

% Undertake practice test
h = 1; % Create Practice Test Variable
while h == 1
    % Give instruction and wait for key press to continue
    fprintf('\nPress any key to begin PRACTICE round\n\n');
    pause
    % Keep subject updates
    fprintf('Playing Ambisonic Render "A"...\n\n');
    % Play a practice sample
    sound(w, fs, 16); % 3O Large Room
    pause(10)
    fprintf('Press any key to hear the "B" test\n\n');
    pause
    % Play a second practice sample
    sound(u,fs, 16); % 1O Small Room
    fprintf('Playing Ambisonic Render "B"...\n\n');
    pause(10)
    fprintf('Press any key to hear the "X" test\n\n');
    pause
    % Randomly select a sample from the two just played
    l = randi(2);
    fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
        % Play test A if l = 1
        if l == 1
            sound(w, fs, 16);
        % Play test B if l = 2
        else
            sound(u, fs, 16); 
        end
        pause(10)
        b = 1;
        % Allow the subject to replay a specific track
        while b == 1
            repeat = input('If you wish to hear specific tracks again, please select which.\n (1 = A, 2 = B, 3 = Mystery (X), 4 = Continue) \n\n');
            if repeat == 4
                b = 0;
            end
            if repeat == 3
                if l == 1
                    fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                    sound(w, fs, 16);
                else
                    fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                    sound(u, fs, 16);
                end
            end
            if repeat == 2
                sound(u,fs, 16); % 1O
                fprintf('Playing Ambisonic Render "B"...\n\n');
            end
            if repeat == 1
                fprintf('Playing Ambisonic Render "A"...\n\n');
                sound(w, fs, 16); % 3O   
            end
        end
    Q = 0; % Practice Matrix
        % Record result in a dummy matrix
    while Q ~= 1 && Q ~= 2 
        Q = input('\nWhich track (A or B) was equivalent to the mystery track? (1 = A, 2 = B) ');
        % Only let 1 or 2 be entered
        if isempty(Q) == true 
            Q = 0;
        end
    end
    % Ask user if they require another practice test
    h = input('\n\nWould you like the practice test again? (1 = Yes, 0 = No) ');  
end %END WHILE
% Print instructions
fprintf('\nPress any key to begin REAL LISTENING TEST\n\n');
pause

% Begin experiment
for i = 1:3
    % Display the test number at the beginning of every test
    if i == 1
        fprintf('SMALL ROOM TESTS\n\n');
    elseif i == 2
        fprintf('MEDIUM ROOM TESTS\n\n');
    else
        fprintf('LARGE ROOM TESTS\n\n');
    end
    
    for j = 1:3
        g = 1; % Create matrix test variable
        while g == 1 
            % Read in the sample audio files under different variables
            [x,~] = audioread(char(M(i, S))); % FOA Small/Med/Large
            [y,~] = audioread(char(M(i, T))); % 2OA Small/Med/Large
            [z,fs] = audioread(char(M(i, U))); % 3OA Small/Med/Large

            if j == 1
                % Calculate Test number based on i and j
                fprintf('\nTEST %d\n', 3*(i-1)+j);
                fprintf('Press any key to hear the "A" test\n\n');
                pause
                fprintf('Playing Ambisonic Render "A"...\n\n');
                % Play subject the first sample file
                sound(z, fs, 16); % 3O
                pause(10)
                fprintf('Press any key to hear the "B" test\n\n');
                pause
                fprintf('Playing Ambisonic Render "B"...\n\n');
                % Play subject the second sample file
                sound(y,fs, 16); % 2O
                pause(10)
                fprintf('Press any key to hear the "X" Test\n\n')
                pause
                % Randomly select an audio file from the previous two
                k = randi(2);
                fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                if k == 1
                    % Play the first sample if k = 1
                    sound(z, fs, 16);
                else
                    % Play the second if k = 2
                    sound(y, fs, 16);
                end
                pause(10)
                a = 1;
                % Allow the subject to replay specific tracks
                while a == 1
                    repeat = input('If you wish to hear specific tracks again, please select which.\n (1 = A, 2 = B, 3 = Mystery (X), 4 = Continue)\n\n');
                    if repeat == 4
                        a = 0;
                    end
                    if repeat == 3
                        if k == 1
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(z, fs, 16);
                        else
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(y, fs, 16);
                        end
                    end
                    if repeat == 2
                        sound(y,fs, 16); % 2O
                        fprintf('Playing Ambisonic Render "B"...\n\n');
                    end
                    if repeat == 1
                        fprintf('Playing Ambisonic Render "A"...\n\n');
                        sound(z, fs, 16); % 3O   
                    end
                end
            end
        
        

        
            if j == 2
                fprintf('\nTEST %d\n', 3*(i-1)+j);
                fprintf('Press any key to hear the "A" test\n\n')
                pause
                fprintf('Playing Ambisonic Render "A"...\n\n');
                sound(z, fs, 16); % 3O
                pause(10)
                fprintf('Press any key to hear the "B" test\n\n')
                pause
                fprintf('Playing Ambisonic Render "B"...\n\n');
                sound(x,fs, 16); % 1O
                pause(10)
                fprintf('Press any key to hear the X test\n\n')
                pause
                k = randi(2);
                fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                % Randomise last listening test
                if k == 1
                    sound(z, fs, 16);
                else
                    sound(x, fs, 16);
                end
                pause(10)
                a = 1;
                while a == 1
                    repeat = input('If you wish to hear specific tracks again, please select which.\n (1 = A, 2 = B, 3 = Mystery (X), 4 = Continue)\n\n');
                    if repeat == 4
                        a = 0;
                    end
                    if repeat == 3
                        if k == 1
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(z, fs, 16);
                        else
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(x, fs, 16);
                        end
                    end
                    if repeat == 2
                        sound(x,fs, 16); % 1O
                        fprintf('Playing Ambisonic Render "B"...\n\n');
                    end
                    if repeat == 1
                        fprintf('Playing Ambisonic Render "A"...\n\n');
                        sound(z, fs, 16); % 3O   
                    end
                end
            end
                 
            if j == 3
                fprintf('\nTEST %d\n', 3*(i-1)+j);
                fprintf('Press any key to hear the "A" test\n\n');
                pause
                fprintf('Playing Ambisonic Render "A"...\n\n');
                sound(y, fs, 16); % 2O
                pause(10)
                fprintf('Press any key to hear the "B" test\n\n');
                pause
                fprintf('Playing Ambisonic Render "B"...\n\n');
                sound(x,fs, 16); % 1O
                pause(10) 
                fprintf('Press any key to hear the "X" test\n\n');
                pause
                k = randi(2);
                fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                if k == 1
                    sound(y, fs, 16); %2O
                else
                    sound(x, fs, 16); % 1O
                end
                pause(10)
                a = 1;
                while a == 1
                    repeat = input('If you wish to hear specific tracks again, please select which.\n (1 = A, 2 = B, 3 = Mystery (X), 4 = Continue)\n\n');
                    if repeat == 4
                        a = 0;
                    end
                    if repeat == 3
                        if k == 1
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(y, fs, 16);
                        else
                            fprintf('Playing Mystery-Order Ambisonic Render...\n\n');
                            sound(x, fs, 16);
                        end
                    end
                    if repeat == 2
                        sound(x,fs, 16); % 1O
                        fprintf('Playing Ambisonic Render "B"...\n\n');
                    end
                    if repeat == 1
                        fprintf('Playing Ambisonic Render "A"...\n\n');
                        sound(y, fs, 16); % 2O   
                    end
                end
                
            end

            % Populate Matrix P with the subjects answers 
            while P(i,j) ~= 1 && P(i,j) ~= 2 
                % Only allow 1 and 2 to be entered
                P(i,j) = input('\nWhich track (A or B) was equivalent to the mystery track? (1 = A, 2 = B) ');
            end
            % Populate Matrix K with true answers
            K(i,j) = k;
            g=0;
            clc
            
        end % END WHILE
    end % END SECOND FOR LOOP
end % END FIRST FOR LOOP
                                                                                                           
        fprintf('Press any key to continue\n\n')
        pause  
        
 % END INITIAL FOR LOOP
disp('This concludes the test.  Thank you.')
% Create Results Matrix
R(9,1) = 0;
index = 1;
for i = 1:3 % Append column array via recursion
    for j = 1:3
        % Equate the Results matrix to the perceived results minus the true results
        % A 9x1 matrix will be created. 
        % Each correct answer will populate matrix with a '0'.
        % All incorrect answers will be non-zero in value
        % If answer is correct, there is a perceptual difference, if
        % incorrect, then no perceptual difference.
        R(index,1) = R(index,1) + abs(P(i,j)-K(i,j));
        index = index + 1;
    end
end
% SAVE array of updated results (column array)
fprintf('Writing results to .csv file...\n\n')
save('results.csv','R', '-ascii')
fprintf('Completed! Please send the file "results.csv" back to host.\n\n')

