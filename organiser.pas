unit organiser;

interface

uses
  Windows, Messages, SysUtils, Variants,dmChess_u, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, ExtCtrls, DBCtrls, Buttons;

type
  TFOrganiser = class(TForm)
    DBregestration: TDBGrid;
    Label1: TLabel;
    DBNavigator1: TDBNavigator;
    btnSort: TButton;
    CBsort: TComboBox;
    Label2: TLabel;
    firstnamecheck: TCheckBox;
    Lastnamecheck: TCheckBox;
    Birthday: TCheckBox;
    Members: TCheckBox;
    Wins: TCheckBox;
    Loses: TCheckBox;
    Draw: TCheckBox;
    Report: TLabel;
    btnReport: TButton;
    DBGrid1: TDBGrid;
    DBNavigator2: TDBNavigator;
    Edtsearch: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    btnFilter: TBitBtn;
    btnReset: TButton;
    Label5: TLabel;
    btnMatch: TButton;
    Boardcolor: TRadioGroup;
    edtRound: TEdit;
    Label6: TLabel;
    edtBoardnumber: TEdit;
    Boardnumber: TLabel;
    btnUpdate: TButton;
    edtDeleteFirst: TEdit;
    edtDeleteLast: TEdit;
    btnDelete: TButton;
    Label7: TLabel;
    BtnMatchReport: TButton;
    Label8: TLabel;
    procedure btnSortClick(Sender: TObject);
    procedure btnReportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnFilterClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnMatchClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure BtnMatchReportClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FOrganiser: TFOrganiser;
  var firstnamewhite,lastnamewhite,firstnameblack,lastnameblack:string;
implementation

{$R *.dfm}

procedure TFOrganiser.btnDeleteClick(Sender: TObject);
var firstname,lastname:string;
begin
firstname:=edtDeleteFirst.Text;
lastname:=edtDeleteLast.Text;
with dmchess do
 if tblregistration.Locate('first_name',firstname,[]) = TRUE and tblregistration.Locate('last_name',lastname,[]) then
  begin      //finds the reocrd with the request fist and last name
   tblregistration.Delete;//delets the records
   showmessage('Record deleted');
  end;
end;

procedure TFOrganiser.btnFilterClick(Sender: TObject);
var search:string;
begin
search:=edtsearch.Text;
with dmchess do
dmChess.matchresults.Filtered:=false; //filters for the requested names of the user
dmChess.matchresults.Filter:='first_name_white=' + quotedstr(search)+' or '+'first_name_black=' + quotedstr(search);
dmChess.matchresults.Filtered:=true;
end;

procedure TFOrganiser.btnMatchClick(Sender: TObject);

begin
firstNamewhite:=inputbox('Name','Please type in the First name of the player on White','');//gathers the participant of thematch
lastnamewhite:=inputbox('Name','Please type in the Lastname of the player on White','');
firstnameblack:=inputbox('Name','Please type in the First name of the player on Black','');
lastnameblack:=inputbox('Name','Please type in the Last name of the player on Black','');
end;

procedure TFOrganiser.BtnMatchReportClick(Sender: TObject);
var score:string;
    loop,num,slength,drawsnumber:integer;
    scorereport:textfile;
    line:string;
begin
assignfile(scorereport,'.\Reports\Scores.txt');
rewrite(scorereport);
writeln(scorereport,'First name'+'  Last name'+'    Scores');//assign file
dmChess.tblregistration.First;
loop:=8;
while loop<15 do
begin
if dmChess.tblregistration.locate('ID',loop,[]) then  //generates the scores and inputs into files
   begin
   line:=dmChess.tblregistration['first_name'];
   line:=line+#9+dmChess.tblregistration['last_name'];
   line:=line+#9+inttostr(dmChess.tblregistration['wins']+(dmChess.tblregistration['draws']*0.5));
   inc(loop);
   writeln(scorereport,line);
   end;

   dmchess.tblregistration.next;
end;

closefile(scorereport);
end;


procedure TFOrganiser.btnReportClick(Sender: TObject);
var sLine, sHeader: String;
    report : TextFile;

begin
 AssignFile(report,'.\Reports\Report.txt');
 ReWrite(report);

 if firstnamecheck.Checked then sHeader := sHeader + 'First Name' + #9;//Puts the headers into the file if they requested that column
 if lastnamecheck.Checked then sHeader := sHeader + 'Last Name' + #9;
 if Birthday.Checked then sHeader := sHeader + 'Birthday' + #9 + #9;
 if Members.Checked then sHeader := sHeader + 'Members' + #9 ;
 if Wins.Checked then sHeader := sHeader + 'Wins' + #9 ;
 if Loses.Checked then sHeader := sHeader + 'Loses' + #9 ;
 if Draw.Checked then sHeader := sHeader + 'Draw' + #9 ;

Writeln(report,sHeader);

dmChess.tblregistration.First;
while not dmChess.tblRegistration.Eof do
BEGIN
sline:='';
 if firstnamecheck.Checked then sLine := sLine + dmChess.tblRegistration['first_name'] + #9 + #9;     //checks of the user requested that headers and generates the textfiles

 if lastnamecheck.Checked then sLine := sLine + dmChess.tblRegistration['last_name'] + #9 + #9;

 if Birthday.Checked then sLine := sLine + datetostr(dmChess.tblRegistration['birthday']) + #9 + #9;

 if Members.Checked then
   if dmChess.tblregistration['member']=true then
     sLine := sLine + 'true' + #9 + #9
     else sLine := sLine + 'false' + #9 + #9;

 if Wins.Checked then sLine := sLine + inttostr(dmChess.tblRegistration['wins']) + #9;

 if Loses.Checked then sLine := sLine + inttostr(dmChess.tblRegistration['loses']) + #9;

 if Draw.Checked then sLine := sLine + inttostr(dmChess.tblRegistration['draws']) + #9;

 WriteLn(report,sline);
 dmChess.tblregistration.Next;
END;

Closefile(report);
end;


procedure TFOrganiser.btnSortClick(Sender: TObject);
var sort:string;
begin
sort:=CBsort.Text;
dmChess.tblregistration.Sort:=sort //Sorts the grid by the requested column
end;

procedure TFOrganiser.btnUpdateClick(Sender: TObject);
var roundnum,boardnum,winner:string;

begin
dmchess.matchresults.Insert;
if dmchess.tblregistration.Locate('first_name',firstnamewhite,[]) then
dmchess.matchresults['first_name_white']:=firstnamewhite //inputs the firstwhite into the db
else
begin
firstNamewhite:=inputbox('error','Please type in the First name of the player on White again','');
exit;
end;
if dmchess.tblregistration.Locate('last_name',lastnamewhite,[]) then   //inputs the lastwhite into the db
dmchess.matchresults['last_name_white']:=lastnamewhite
else
begin
lastnamewhite:=inputbox('Error','Please type in the Lastname of the player on White again','');
exit;
end;
if dmchess.tblregistration.Locate('first_name',firstnameblack,[]) then       //inputs the firstblack into the db
dmchess.matchresults['first_name_black']:=firstnameblack
else
begin
firstnameblack:=inputbox('Error','Please type in the Firstname of the player on Black again','');
exit;
end;
if dmchess.tblregistration.Locate('last_name',lastnameblack,[]) then  //inputs the lastblack into the db
dmchess.matchresults['last_name_black']:=lastnameblack
else
begin
firstnameblack:=inputbox('Error','Please type in the Lastname of the player on Black again','');
exit;
end;
if boardcolor.ItemIndex=-1 then
showmessage('Please select the result of the match');
if boardcolor.ItemIndex=0 then    //edits all of the scores in the DB depending on the results
begin
dmchess.matchresults['scores_black']:=1;
dmchess.matchresults['scores_white']:=0;
if dmchess.tblregistration.Locate('First_name',Firstnameblack,[]) and dmchess.tblregistration.Locate('Last_name',Lastnameblack,[]) then
  begin
  dmchess.tblregistration.Edit;
  dmchess.tblregistration['wins']:=dmchess.tblregistration['wins']+1;
  dmchess.tblregistration.Post;
if dmchess.tblregistration.Locate('First_name',Firstnamewhite,[]) and dmchess.tblregistration.Locate('Last_name',Lastnamewhite,[])then
   dmchess.tblregistration.Edit;
  dmchess.tblregistration['loses']:=dmchess.tblregistration['loses']+1;
  dmchess.tblregistration.Post;
  end;
end;
if boardcolor.ItemIndex=1 then
dmchess.matchresults['scores_white']:=1;
dmchess.matchresults['scores_black']:=0;
if dmchess.tblregistration.Locate('First_name',Firstnamewhite,[]) and dmchess.tblregistration.Locate('Last_name',Lastnamewhite,[]) then
  begin
  dmchess.tblregistration.Edit;
  dmchess.tblregistration['wins']:=dmchess.tblregistration['wins']+1;
  dmchess.tblregistration.Post;
if dmchess.tblregistration.Locate('First_name',Firstnameblack,[]) and dmchess.tblregistration.Locate('Last_name',Lastnameblack,[])then
   dmchess.tblregistration.Edit;
  dmchess.tblregistration['loses']:=dmchess.tblregistration['loses']+1;
  dmchess.tblregistration.Post;
  end;
if boardcolor.Itemindex=2 then
begin
dmchess.matchresults['scores_white']:=0.5;
dmchess.matchresults['scores_black']:=0.5;

if dmchess.tblregistration.Locate('First_name',Firstnamewhite,[]) and dmchess.tblregistration.Locate('Last_name',Lastnamewhite,[]) then //locates the record of the requested user and then edits the names
  begin
  dmchess.tblregistration.Edit;
  dmchess.tblregistration['draws']:=dmchess.tblregistration['draws']+1;
  dmchess.tblregistration.Post;
if dmchess.tblregistration.Locate('First_name',Firstnameblack,[]) and dmchess.tblregistration.Locate('Last_name',Lastnameblack,[])then
   dmchess.tblregistration.Edit;
  dmchess.tblregistration['draws']:=dmchess.tblregistration['draws']+1;
  dmchess.tblregistration.Post;
end;
end;
dmchess.matchresults['round_number']:=edtround.Text; //edits the round number in tbl matches
dmchess.matchresults['board_number']:=edtboardnumber.Text; //edits the board number in tbl matches
dmchess.matchresults.Post;



end;

procedure TFOrganiser.btnResetClick(Sender: TObject);
begin
dmChess.matchresults.Filtered:=false;//resets the table of the matchresults
end;

procedure TFOrganiser.FormCreate(Sender: TObject);
begin
dmchess.matchresults.Sort:='round_number DESC,board_number DESC';  //Default order of the matchresult table
end;

end.
