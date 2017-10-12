function varargout = GetRegionStatistics(varargin)
% GETREGIONSTATISTICS M-file for GetRegionStatistics.fig
%      GETREGIONSTATISTICS, by itself, creates a new GETREGIONSTATISTICS or raises the existing
%      singleton*.
%
%      H = GETREGIONSTATISTICS returns the handle to a new GETREGIONSTATISTICS or the handle to
%      the existing singleton*.
%
%      GETREGIONSTATISTICS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GETREGIONSTATISTICS.M with the given input arguments.
%
%      GETREGIONSTATISTICS('Property','Value',...) creates a new GETREGIONSTATISTICS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GetRegionStatistics_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GetRegionStatistics_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GetRegionStatistics

% Last Modified by GUIDE v2.5 25-Jan-2017 10:30:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GetRegionStatistics_OpeningFcn, ...
                   'gui_OutputFcn',  @GetRegionStatistics_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GetRegionStatistics is made visible.
function GetRegionStatistics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GetRegionStatistics (see VARARGIN)

% Choose default command line output for GetRegionStatistics
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GetRegionStatistics wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global CVR_MIN
CVR_MIN = 3;  


% --- Outputs from this function are returned to the command line.
function varargout = GetRegionStatistics_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in LoadCVR.
function LoadCVR_Callback(hObject, eventdata, handles)
% hObject    handle to LoadCVR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ImageType=get(handles.ImageType,'Value');
[fn,pn]=uigetfile('*.*','Find CVF file');
set(handles.CVR_map_path,'String',[pn,fn]);
im=load_nii([pn,fn]);
if ImageType==1
    im.img(im.img<0)=0;  % No CVR < 0
    im.img(im.img>100)=100; % No CVR > 100%
end
cd(pn);
set(handles.LoadCVR','Userdata',im.img);

% --- Executes on button press in Load_GM_Mask.
function Load_GM_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to Load_GM_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn]=uigetfile('*.*','Find GN mask');
set(handles.GM_Mask_path,'String',[pn,fn]);
im=load_nii([pn,fn]);
set(handles.Load_GM_Mask,'Userdata',im.img);

% --- Executes on button press in Load_WM_Mask.
function Load_WM_Mask_Callback(hObject, eventdata, handles)
% hObject    handle to Load_WM_Mask (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fn,pn]=uigetfile('*.*','Find GN mask');
set(handles.WM_Mask_path,'String',[pn,fn]);
im=load_nii([pn,fn]);
set(handles.Load_WM_Mask','Userdata',im.img);


function NumPermutations_Callback(hObject, eventdata, handles)
% hObject    handle to NumPermutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumPermutations as text
%        str2double(get(hObject,'String')) returns contents of NumPermutations as a double


% --- Executes during object creation, after setting all properties.
function NumPermutations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumPermutations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Load_Lesions.
function Load_Lesions_Callback(hObject, eventdata, handles)
% hObject    handle to Load_Lesions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.LesionToggle,'Value')==0
    prompt = 'Find Lesion Map';
else
    prompt = 'Find Lesion List';
end
[fn,pn]=uigetfile('*.*',prompt);
set(handles.Lesions_path,'String',[pn,fn]);
if get(handles.LesionToggle,'Value')==1     % if it is a binary map of all lesions then
    load([pn,fn]);
    set(handles.Load_Lesions,'Userdata',Lesions);
else
    im=load_nii([pn,fn]);
    set(handles.Load_Lesions,'Userdata',im.img);
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in LesionToggle.
function LesionToggle_Callback(hObject, eventdata, handles)
% hObject    handle to LesionToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of LesionToggle
if get(hObject,'Value') == 1
    set(hObject,'String','Lesion List')
    set(handles.Load_Lesions,'String','Load Lesion List')
else
    set(hObject,'String','Lesion Map')
    set(handles.Load_Lesions,'String','Load Lesion Map')
end


% --- Executes on button press in Go.
function Go_Callback(hObject, eventdata, handles)
% hObject    handle to Go (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
GM=get(handles.Load_GM_Mask,'Userdata');  % Get grey matter mask
WM=get(handles.Load_WM_Mask,'Userdata');  % Get white matter mask
BrainMask=GM+WM;                          % Form a total brain(nonCSF) mask
% save_nii(make_nii(BrainMask,[1,1,1]),'WholeBrain.nii');

Debug=BrainMask-BrainMask;                % Null matrix
Debug2=BrainMask-BrainMask;                % Null matrix
Threshold=str2num(get(handles.ErosionThreshold,'String'));
CVR=get(handles.LoadCVR,'Userdata');      % Get CVR map
[Nrows,Ncols,Nslices]=size(CVR);
Lesions=get(handles.Load_Lesions,'Userdata'); % Get the lesion map or list
if get(handles.LesionToggle,'Value')==0     % if it is a binary map of all lesions then
    L=bwlabeln(Lesions);                  % label the lesions
    Lesions=regionprops(L,'Centroid','BoundingBox','PixelList'); % calculate their position, size, and coordinates
end
NumLesions=length(Lesions);                % this is the # of lesions to permute
set(handles.NumLesions,'String',num2str(NumLesions)); % update the GUI variable
Permutations=str2num(get(handles.NumPermutations,'String')) % Find the # of permutations. 
LC=0; % Set lesioncounter
for i=1:NumLesions                      % Repeat for each lesion
    if mod(i,100)==0
        fprintf('%s \n',['Lesion #',num2str(i)]);
    end
    if Lesions(i).Centroid(3)>40
        LC = LC + 1;  
        ActualCVR(LC)=mean(CVR(sub2ind(size(CVR), Lesions(i).PixelList(:,2), Lesions(i).PixelList(:,1), Lesions(i).PixelList(:,3))));
        if ActualCVR(LC)<5
            Debug2(sub2ind(size(CVR), Lesions(i).PixelList(:,2), Lesions(i).PixelList(:,1), Lesions(i).PixelList(:,3)))=1; % save the critical lesions. 
        end

        ErosionMask=ones(ceil(Lesions(i).BoundingBox(5)/2), ceil(Lesions(i).BoundingBox(4)/2), ceil(Lesions(i).BoundingBox(6)/2)); % calculate how much to erode
        Brain_Eroded=imerode(BrainMask,ErosionMask)>Threshold;    % erode the whole brain mask for i'th lesion
        Brain_Indices=find(Brain_Eroded == 1);          % find the possible new centroids for the lesion in whole brain for i'th lesion
        WM_Eroded=imerode(WM,ErosionMask)>Threshold;    % erode the white matter mask for i'th lesion
        WM_Indices=find(WM_Eroded == 1);                % find the possible new centroids for the lesion in white matter alone for i'th lesion
        BM_Num=length(Brain_Indices);                    % number of unique possible permutations in whole brain for i'th lesion
        WM_Num=length(WM_Indices);                       % number of unique possible permutations in white matter for i'th lesion
        [LesionLength(LC),dummy]=size(Lesions(i).PixelList);      % number of pixels in i'th lesion
        for k=1:Permutations                % Move the i'th lesion into #Permutations new locations.   
            if BM_Num > 0
                counter = 0;
                while counter < 3
                    [BM.x,BM.y,BM.z]=ind2sub(size(CVR),Brain_Indices(ceil(rand*BM_Num)));  % New centroid for i'th lesion using whole brain.
                    Shift=repmat([round(BM.y-Lesions(i).Centroid(1)),round(BM.x-Lesions(i).Centroid(2)), round(BM.z-Lesions(i).Centroid(3))],[LesionLength(LC),1]); % amount of x,y,z shift
                    NewLesionLoc=Lesions(i).PixelList+Shift; % New position for the lesion. 
                    if (min(NewLesionLoc(:))) > 0 && (max(NewLesionLoc(:,2))<Ncols) && (max(NewLesionLoc(:,1))< Nrows) && (max(NewLesionLoc(:,3))<Nslices)
                        counter = 10;
                    else
                        counter = counter+1;
                    end
                end
                if counter== 10
                    NewBM_CVR(LC,k)=mean(CVR(sub2ind(size(CVR),NewLesionLoc(:,2),NewLesionLoc(:,1), NewLesionLoc(:,3)))); % calculate the average CVR for new position
                    Debug(sub2ind(size(CVR),NewLesionLoc(:,2),NewLesionLoc(:,1), NewLesionLoc(:,3)))=1;  % record new lesion locations
                else
                    ['Lesion ', num2str(i),' failed, Centroid = ', num2str(Lesions(i).Centroid), ' Bounding Box =', num2str(Lesions(i).BoundingBox)]
                end
            end
            if WM_Num > 0
                counter = 0;
                while counter < 3
                    [WMI.x,WMI.y,WMI.z]=ind2sub(size(CVR),WM_Indices(ceil(rand*WM_Num)));     % New centroid for lesion confined to WM.
                    Shift=repmat([round(WMI.y-Lesions(i).Centroid(1)),round(WMI.x-Lesions(i).Centroid(2)), round(WMI.z-Lesions(i).Centroid(3))],[LesionLength(LC),1]);
                    NewLesionLoc=Lesions(i).PixelList+Shift;
                    if (min(NewLesionLoc(:))) > 0 && (max(NewLesionLoc(:,2))<Ncols) && (max(NewLesionLoc(:,1))< Nrows) && (max(NewLesionLoc(:,3))<Nslices)
                        counter = 10;
                    else
                        counter = counter+1;
                    end
                end
                if counter== 10
                    NewWM_CVR(LC,k)=mean(CVR(sub2ind(size(CVR),NewLesionLoc(:,2),NewLesionLoc(:,1), NewLesionLoc(:,3))));
                else
                    ['Lesion ', num2str(i),' failed, Centroid = ', num2str(Lesions(i).Centroid), ' Bounding Box =', num2str(Lesions(i).BoundingBox)]
                end
            end
        end
    end
end
set(handles.NumLesions,'String',num2str(LC));
save_nii(make_nii(Debug,[1,1,1]),'AllPermutations.nii');
% save_nii(make_nii(Debug2,[1,1,1]),'CriticalLesions.nii');
set(handles.PlotAll,'Userdata',LesionLength);
set(handles.NumLesions,'Userdata',ActualCVR);
if exist('NewBM_CVR','var')
    set(handles.Go,'Userdata',NewBM_CVR);
end
if exist('NewWM_CVR','var')
    set(handles.NumPermutations,'Userdata',NewWM_CVR);
end
'Done'

        


function NumLesions_Callback(hObject, eventdata, handles)
% hObject    handle to NumLesions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumLesions as text
%        str2double(get(hObject,'String')) returns contents of NumLesions as a double


% --- Executes during object creation, after setting all properties.
function NumLesions_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLesions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Earlier.
function Earlier_Callback(hObject, eventdata, handles)
% hObject    handle to Earlier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Active=str2num(get(handles.ActiveLesion,'String'));
Skip=str2num(get(handles.SkipFactor,'String'));
Active = Active - Skip;
if Active<1
    Active = 1;
end
set(handles.ActiveLesion,'String',num2str(Active));
UpdateViewport(handles);

% --- Executes on button press in Later.
function Later_Callback(hObject, eventdata, handles)
% hObject    handle to Later (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Active=str2num(get(handles.ActiveLesion,'String'));
NumLesions=str2num(get(handles.NumLesions,'String'));
if ~isempty(NumLesions)
    Skip = str2num(get(handles.SkipFactor,'String'));
    Active = Active + Skip;
    if Active > NumLesions
        Active = NumLesions;
    end
    set(handles.ActiveLesion,'String',num2str(Active));
    UpdateViewport(handles);
end


function ActiveLesion_Callback(hObject, eventdata, handles)
% hObject    handle to ActiveLesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ActiveLesion as text
%        str2double(get(hObject,'String')) returns contents of ActiveLesion as a double
Active=str2num(get(handles.ActiveLesion,'String'));
NumLesions=str2num(get(handles.NumLesions,'String'));
if ~isempty(NumLesions)
    if Active<1
        Active = 1;
    else if Active > NumLesions
            Active = NumLesions;
        end
    end
    set(handles.ActiveLesion,'String',num2str(Active));
    UpdateViewport(handles)
else
    set(handles.ActiveLesion,'String','1');
end

% --- Executes during object creation, after setting all properties.
function ActiveLesion_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ActiveLesion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PlotAll.
function PlotAll_Callback(hObject, eventdata, handles)
% hObject    handle to PlotAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
STEP = 5.0
global CVR_MIN
axes(handles.ViewPort)
if get(handles.RegionToggle,'Value')==0
    background=get(handles.NumPermutations,'Userdata');
else
    background=get(handles.Go,'Userdata');
end
NumPermutations=str2num(get(handles.NumPermutations,'String'));
LesionLength=get(hObject,'Userdata');
Actual_CVR = get(handles.NumLesions,'Userdata');
x=[0:STEP:max(Actual_CVR)];
valid=find(background(:)>CVR_MIN);
background2=squeeze(background(valid));
[hb]=hist(background2(:),x); 
figure;
plot(x,hb/sum(hb),'b','LineWidth',3); 
hold on

valid=find(Actual_CVR>CVR_MIN);
Actual_CVR=squeeze(Actual_CVR(valid));
LesionLength=LesionLength(valid);
[ha]=hist(Actual_CVR(:),x); 
save('Actual_CVR_venc.mat', 'Actual_CVR');
save('Permuted_CVR_venc.mat', 'background2');

plot(x,ha/sum(ha),'r','LineWidth',3); 
hold off
[H,p1]=kstest2(background2,Actual_CVR);
H

% [H,p]=ttest2(background(1:length(Actual_CVR)),Actual_CVR);
[H,p2]=ttest2(mean(background, 2),Actual_CVR);
H
['2 Sample T-test p = ',num2str(p2, '%.5e'),', ', num2str(mean(Actual_CVR)),' vs ',num2str(mean(background2))]

% [H,p3]=vartest2(mean(background, 2),Actual_CVR);
% H
% ['2 Sample Variance-test p = ',num2str(p3, '%.5e'),', ', num2str(std(Actual_CVR)),' vs ',num2str(std(background2))]

legend('Reference', 'Lesions');
str = {['KS-Test p=',num2str(p1,'%4.4e')], ['t-Test p=',num2str(p2,'%4.4e')]};
t = text(10, 0.2, str);
t.FontSize = 12;
xlabel('CBF values'); ylabel('Frequency of appearance');title('Histogram of lesion vs. non-lesion CBF values');
% saveas(gcf, 'perm.jpg');
background=double(background');
Actual_CVR=double(Actual_CVR');
LesionLength=double(LesionLength');
% save background background -ascii -tabs
% save background background 
% save ActualCVR Actual_CVR -ascii -tabs
% save ActualCVR Actual_CVR 
% save LesionLength LesionLength -ascii -tabs
% save LesionLength LesionLength 

% [h]=hist((Actual_CVR.*LesionLength(valid))./sum(LesionLength(valid)),x); 
% plot(x,h/sum(h),'g'); 


function SkipFactor_Callback(hObject, eventdata, handles)
% hObject    handle to SkipFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SkipFactor as text
%        str2double(get(hObject,'String')) returns contents of SkipFactor as a double


% --- Executes during object creation, after setting all properties.
function SkipFactor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SkipFactor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function UpdateViewport(handles)
global CVR_MIN
display=get(handles.RegionToggle,'Value');
if display == 1
    data=get(handles.Go,'Userdata');
else
    data=get(handles.NumPermutations,'Userdata');
end

ActualCVR=get(handles.NumLesions,'Userdata');
ActiveLesion = str2num(get(handles.ActiveLesion,'String'));

if ~isempty(data) & ActualCVR(ActiveLesion)>CVR_MIN
    DataLine=squeeze(data(ActiveLesion,:));
    valid=find(DataLine>CVR_MIN);
    DataLine=DataLine(valid);
    p=sum(DataLine<ActualCVR(ActiveLesion))/length(DataLine);
    axes(handles.ViewPort);
    x=[0:2.5:100];
    [h]=hist(DataLine,x);
    plot(x,h);
    hold;
    plot([ActualCVR(ActiveLesion),ActualCVR(ActiveLesion)],[0,max(h)],'r');
    legend(['p-value = ',num2str(p)]);
    hold;
end
    



function ErosionThreshold_Callback(hObject, eventdata, handles)
% hObject    handle to ErosionThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ErosionThreshold as text
%        str2double(get(hObject,'String')) returns contents of ErosionThreshold as a double
Threshold = str2num(get(hObject,'String'));
if Threshold > 1
    set(hObject,'String','1');
else
    if Threshold < 0
        set(hObject,'String','0');
    end
end

% --- Executes during object creation, after setting all properties.
function ErosionThreshold_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ErosionThreshold (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RegionToggle.
function RegionToggle_Callback(hObject, eventdata, handles)
% hObject    handle to RegionToggle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of RegionToggle
if get(hObject,'Value')==1
    set(hObject,'String','WM + GM Mask')
else
    set(hObject,'String','WM Mask Only')
end


% --- Executes on button press in ImageType.
function ImageType_Callback(hObject, eventdata, handles)
% hObject    handle to ImageType (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ImageType
if get(hObject,'Value')==1
    set(hObject,'String','CVR');
else
    set(hObject,'String','Flow');
end