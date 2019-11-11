function comet_tracking3_Z(varargin)
% comet_tracking3(sinZ, t, cosZ) z input
% Parse possible Axes input
[ax,args,nargs] = axescheck(varargin{:});

if nargs < 1
    error(message('MATLAB:narginchk:notEnoughInputs'));
elseif nargs > 4
    error(message('MATLAB:narginchk:tooManyInputs'));
end

% Parse the rest of the inputs
if nargs < 2, x = args{1}; end
if nargs == 2, y = args{2}; end
if nargs < 3, z = x; x = 1:length(z); y = 1:length(z); end
if nargs == 3, [x,y,z] = deal(args{:}); end
if nargs < 4, p = 0.10; end
if nargs == 4, [x,y,z,p] = deal(args{:}); end

if ~isscalar(p) || ~isreal(p) || p < 0 || p >= 1
    error(message('MATLAB:comet3:InvalidP'));
end

x = datachk(x);
y = datachk(y);
z = datachk(z);

ax = newplot(ax);
grid on
annotation('textarrow',[0.6,0.45],[0.25, 0.35], 'LineWidth', 3,'String','initial view ', 'FontSize',14)
title('Motion tracking: roll (z angle)', 'FontSize', 14)
xlabel('sin\theta_t', 'FontSize', 14)
ylabel('time slots', 'FontSize', 14)
zlabel('cos\theta_t', 'FontSize', 14)
if ~strcmp(ax.NextPlot,'add')
    % If NextPlot is 'add', assume other objects are driving the limits.
    % Otherwise, set the limits so that the axes limits don't jump around
    % during animation.
    [minx,maxx] = minmax(x);
    [miny,maxy] = minmax(y);
    [minz,maxz] = minmax(z);
    axis(ax,[minx maxx miny maxy minz maxz])
end

% co = get(ax,'colororder');
co = [[1 0 0];[0 128/255 1];[51/255 51/255 1]];

if size(co,1)>=3
    colors = [ co(1,:);co(2,:);co(3,:)];
    lstyle = '-';
else
    colors = repmat(co(1,:),3,1);
    lstyle ='--';
end

m = length(z);
% k = round(p*m);
k = 0; % body length k=0 no body

head = line('parent',ax,'color',colors(1,:),'marker','o','Markersize',12, ...
    'linewidth',3,'xdata',x(1),'ydata',y(1),'zdata',z(1),'tag','head');

% Choose first three colors for head, body, and tail
body = animatedline('parent',ax,'color',colors(2,:),'linestyle',lstyle,...
    'linewidth',2,'MaximumNumPoints',max(1,k),'Tag','body');
tail = animatedline('parent',ax,'color',colors(3,:),'linestyle','-',...
    'linewidth',2,'MaximumNumPoints',1+m, 'Tag','tail');

if length(x) < 2000
    updateFcn = @()drawnow;
else
    updateFcn = @()drawnow('limitrate');
end
filename = 'motion_tracking_video1_z.gif';
% Grow the body
for i = 1:k
    % pause(.1)
    % Protect against deleted objects following the call to drawnow.
    if ~(isvalid(head) && isvalid(body))
        return
    end
    set(head,'xdata',x(i),'ydata',y(i),'zdata',z(i))
    addpoints(body,x(i),y(i),z(i));
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/24);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/24);
    end
    updateFcn();
end

% Add a drawnow to capture any events / callbacks
drawnow

% Primary loop
m = length(x);
for i = k+1:m
    % pause(.1)
    % Protect against deleted objects following the call to drawnow.
    if ~(isvalid(head) && isvalid(body) && isvalid(tail))
        return
    end
    set(head,'xdata',x(i),'ydata',y(i),'zdata',z(i))
    addpoints(body,x(i),y(i),z(i));
    addpoints(tail,x(i-k),y(i-k),z(i-k));
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/24);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/24);
    end
    updateFcn();
end
drawnow

% Clean up the tail
for i = m+1:m+k
    % pause(.1)
    % Protect against deleted objects following the call to drawnow.
    if ~isvalid(tail)
        return
    end
    addpoints(tail, x(i-k),y(i-k),z(i-k));
    frame = getframe(gcf);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    % Write to the GIF File
    if i == 1
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',1/24);
    else
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',1/24);
    end
    updateFcn();
end
drawnow

% same subfunction as in comet
function [minx,maxx] = minmax(x)
minx = min(x(isfinite(x)));
maxx = max(x(isfinite(x)));
if minx == maxx
    minx = maxx-1;
    maxx = maxx+1;
end
