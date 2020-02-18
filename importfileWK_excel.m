function tableout = importfileWK_excel(workbookFile,sheetName,startRow,endRow)
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
%   InductorS3 = importfile('Inductor.xlsx','kaschke',2,802);
%
%   See also XLSREAD.

% Auto-generated by MATLAB on 2019/02/20 17:48:43

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 3
    startRow = 2;
    endRow = 802;
end

%% Import the data
data = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(1),endRow(1)));
for block=2:length(startRow)
    tmpDataBlock = xlsread(workbookFile, sheetName, sprintf('A%d:C%d',startRow(block),endRow(block)));
    data = [data;tmpDataBlock]; %#ok<AGROW>
end

%% Create table
tableout = table;

%% Allocate imported array to column variable names
tableout.f = data(:,1);
tableout.Ls = data(:,2);
tableout.Rs = data(:,3);
