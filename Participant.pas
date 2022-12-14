unit Participant;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,dmchess_u, Grids, DBGrids,login_form, StdCtrls,dateutils,ComCtrls;

type
  TParticipant_form = class(TForm)
    DBGrid1: TDBGrid;
    edtemail: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EdtUsername: TEdit;
    dtpBirthday: TDateTimePicker;
    edtPassword: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Btnemail: TButton;
    BtnUsername: TButton;
    btnBirthday: TButton;
    btnPassword: TButton;
    procedure BtnemailClick(Sender: TObject);
    procedure BtnUsernameClick(Sender: TObject);
    procedure btnBirthdayClick(Sender: TObject);
    procedure btnPasswordClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Participant_form: TParticipant_form;
  password,sresult:string;
implementation

{$R *.dfm}

procedure TParticipant_form.btnBirthdayClick(Sender: TObject);
var comp,birthdaydate:tdatetime;
    birthdayiscorrect:boolean;
begin
birthdayiscorrect:=true;
birthdaydate:=dateof(dtpBirthday.Date);
comp:=comparedate(today,birthdaydate);
if comp<0 then               //checks if the inputed date occured before the current date
birthdayiscorrect:=false;
if comp=0 then
birthdayiscorrect:=false;

if birthdayiscorrect=true then
 if dmchess.tblregistration.Locate('username',login.loginusername,[])then  //edit specific birthday in DB
    begin
    dmchess.tblregistration.Edit;
    dmchess.tblregistration['birthday']:=birthdaydate;
    dmchess.tblregistration.Post;
    showmessage('Record edited');
end
else showmessage('Please input a valid birthday ');
end;

procedure TParticipant_form.BtnemailClick(Sender: TObject);
var email:string;
    emailiscorrect:boolean;
begin
emailiscorrect:=true;
email:=edtemail.Text;
if  not pos('@',email)=0 then  //checks if it contains @
emailiscorrect:=false;
if not pos('.',email)=0 then  //checks if it contains .
emailiscorrect:=false;
if emailiscorrect=true then
    if dmchess.tblregistration.Locate('username',login.loginusername,[]) then//edits the email in the db
    begin
    dmchess.tblregistration.Edit;
    dmchess.tblregistration['email']:=email;
    dmchess.tblregistration.Post;
    showmessage('Record edited');
    end;
end;

procedure TParticipant_form.btnPasswordClick(Sender: TObject);
var passwordcheck:boolean;
    vlength,loop,asciiNum:integer;
    Npassword:string;
begin
password:=edtPassword.Text;

  vlength:=length(password);

  for loop := 1 to vlength do  //encryption
    begin
    asciiNum :=ord(password[loop]);
    Npassword:=Npassword +chr(asciiNum+vlength);
    end;
sresult:=Npassword;

  showmessage(sresult);
if dmChess.tblregistration.Locate('username',login.loginusername,[]) then
begin
dmChess.tblregistration.Edit;           //edits the password of the specifi user in the db
dmChess.tblregistration['password']:=sresult;
dmChess.tblregistration.Post;
showmessage('Record edited');
end;
end;

procedure TParticipant_form.BtnUsernameClick(Sender: TObject);
var username:string;
begin
username:=edtusername.Text;
if dmchess.tblregistration.Locate('username',login.loginusername,[])then //locates the username record
    begin
    dmchess.tblregistration.Edit;
    dmchess.tblregistration['username']:=username; //edits the username in db
    dmchess.tblregistration.Post;
    showmessage('Record edited');
    end
end;


procedure TParticipant_form.FormActivate(Sender: TObject);
var first_name,last_name:string;
begin
if (dmchess.tblregistration.Locate('username',login.loginusername,[])) then   //locates the user in the records
begin
first_name:=dmchess.tblregistration['first_name']; //allocates the username record
last_name:=dmchess.tblregistration['last_name'];

end;

with dmChess do
begin
matchresults.Filtered:=false; //filters and shows the only matches that the user has perticipated in
matchresults.Filter:='(first_name_white= '+quotedstr(first_name)+' AND last_name_white= '+quotedstr(last_name)+')'+
' OR (first_name_black= '+quotedstr(first_name) +' AND last_name_black= '+quotedstr(last_name)+')';
matchresults.Filtered:=true;
end;

end;
end.
