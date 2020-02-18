function tableout = importfileHP_excel(workbookFile,sheetName,startRow,endRow)
%IMPORTFILE Import data from a spreadsheet
%   DATA = IMPORTFILE(FILE) reads data from the first worksheet in the
%   Microsoft Excel spreadsheet file named FILE and returns the data as a
%   table.
%
%   DATA = IMPORTFILE(FILE,SHEET) reads from the specified worksheet.
%
%   DATA = IMPORTFILE(FILE,SHEET,STARTROW,ENDROW) reads from the specified
%   worksheet for the specified row interval(s). Specify STARTROW and
%   ENDROW as a pair of scalars or vectors of matching size for
%   dis-contiguous row intervals. To read to the end of the file specify an
%   ENDROW of inf.%
% Example:
%   Inductor = importfile('Inductor.xlsx','E498x008',1,201);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2019/02/20 17:47:48

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 1;
    endRow = 201;
end

%% Import the data
data = xlsread(workbookFile, sheetName, sprintf('B%d:E%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    tmpDataBlock = xlsread(workbookFile, sheetName, sprintf('B%d:E%d',startRow(block),endRow(block)));
    data = [data;tmpDataBlock]; %#ok<AGROW>
end

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.Ls = data(:,1);
tableout.Rs = data(:,2);
tableout.VarName4 = data(:,3);
tableout.VarName5 = data(:,4);

