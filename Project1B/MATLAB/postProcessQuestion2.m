% 
close all

colourSpec = 'rbk';

% *************************************************************************
% Question 2b - Explicit Dynamics with Damping
% *************************************************************************

load('Input_Files/Question2/resultsOption4.mat')
deltaT = [100,0.01,1];

figure;
% Plot displacemement vs time of convergent plot solution: 
for i = 1:length(results)
    if (i == 2)
        timeValues = (1:length(results(i).uComplete(11,:))).*deltaT(i);
        plot(timeValues, results(i).uComplete(11,:),...
            colourSpec(i) , 'DisplayName', strcat('\Delta t= ', results(i).timeStep(1:end-4)));
        
        title('Calcuated Displacement vs Time');
        xlabel('Time (ms)');
        ylabel('Displacement (m)');
        legend('show');
    else
        % Uncomment to plot non converging solutions
        %timeValues = (1:length(results(i).uComplete(11,:))).*deltaT(i);
        %plot(timeValues, results(i).uComplete(11,:),...
        %    colourSpec(i) , 'DisplayName', results(i).timeStep);
    end
end

% Plot the order of magnitude of displacement vs time to "blow up" 
for i = 1:length(results)
    if (i ~= 2)
        figure;
        timeValues = (1:length(results(i).uComplete(11,:))).*deltaT(i);
        disp = results(i).uComplete(11,:);
        magnitudeOfDisp = log10(abs(disp)).*sign(disp);
        plot(timeValues, magnitudeOfDisp,'DisplayName',strcat('\Delta t= ', results(i).timeStep(1:end-4)))
        
        title('Magnitude of Calcuated Displacement vs Time');
        xlabel('Time (ms)');
        ylabel('Magnitude of Displacement: log10(|u|)*sign(u)');
        legend('show');
    end
end

% *************************************************************************
% Question 2c - Explicit Dynamics with Damping
% *************************************************************************

load('Input_Files/Question2/resultsOption4.mat')
deltaT = [100,0.01,1];

for i = 1:length(results)
    timeValues = (1:length(results(i).uComplete(11,:))).*deltaT(i);
    plot(timeValues, results(i).uComplete(11,:),...
        colourSpec(i) , 'DisplayName', strcat('\Delta t= ', results(i).timeStep(1:end-4)));

    title('Calcuated Displacement vs Time');
    xlabel('Time (ms)');
    ylabel('Displacement (m)');
    legend('show');
end
