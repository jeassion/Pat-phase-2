unit regestration;

interface

uses
  Windows,strutils, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls,dmChess_u,dateutils, StdCtrls, ComCtrls, Buttons;

type
  TRegister_form = class(TForm)
    edtFirstname: TEdit;
    edtLastName: TEdit;
    Register: TBitBtn;
    Birthday: TDateTimePicker;
    Memebership: TCheckBox;
    edtPassword: TEdit;
    edtEmail: TEdit;
    Image1: TImage;
    tlabel1: TLabel;
    tlabel2: TLabel;
    tlabel3: TLabel;
    tlabel4: TLabel;
    tlaber5: TLabel;
    tlabel7: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure RegisterClick(Sender: TObject);
    procedure validation();
    procedure encryption();
  private
    { Private declarations }
  public
    username,email,password,lastname,firstname:string;
    birthdaydate:tdate;
    membership:boolean;

  end;

var
  Register_form: TRegister_form;
  allcorrect,passwordiscorrect,birthdayiscorrect,emailiscorrect,Surnameiscorrect,Nameiscorrect:boolean;
  today:tdatetime;
  result:string;
implementation
 uses unit4;
{$R *.dfm}

procedure TRegister_form.encryption;
var vlength,loop,asciiNum:integer;
     Npassword:string;
begin                              //encrypt the password to be stored in the DB
  vlength:=length(password);

  for loop := 1 to vlength do
    begin
    asciiNum :=ord(password[loop]);
    Npassword:=Npassword +chr(asciiNum+vlength);
    end;
result:=Npassword;
end;

procedure TRegister_form.FormActivate(Sender: TObject);
begin
memebership.Color:=clCream;

end;

procedure TRegister_form.RegisterClick(Sender: TObject);
var
    passwordcheck:boolean;
begin
firstname:=edtfirstname.Text;   //assigns the variable from the edits
lastname:=edtlastname.Text;
password:=edtPassword.Text;
email:=edtEmail.Text;
birthdaydate:=birthday.Date;
membership:=memebership.Checked;
allcorrect:=true;
validation(); //runs the validation process
encryption();
username:=firstname+lastname;
with dmChess do
  begin
  tblregistration.First;
  while (not tblregistration.Eof) AND (passwordcheck =false) do
  begin
    if tblregistration['password']=result then  //checks if the password is valid
    begin
      messagedlg('Password already exist,please create a new one ',mtWarning,[mbOK],0);
      passwordcheck:=true;
      exit;
    end
  else tblregistration.Next;
  end;

  end;

if emailiscorrect=false then
 Begin
 messagedlg('Please make sure your email is valid.',mtwarning,[mbOK],0);//checks if the email is valid
 edtemail.Color:=clred;
 allcorrect:=false
 End;
if nameiscorrect=false then //checks if the name is valid
begin
 messagedlg('Please make sure your name is valid. Please make sure it only contains letters',mtwarning,[mbOK],0);
 edtfirstname.Color:=clred;
 allcorrect:=false
end;
if surnameiscorrect=false then//checks if the surname is valid
 begin
 messagedlg('Please make sure your surname is valid. Please make sure it only contains letters',mtwarning,[mbOK],0);
 edtlastname.Color:=clred;
 allcorrect:=false
 end;
if passwordiscorrect=false then //checks if the password is valid
begin
 messagedlg('Please make sure you have typed in password ',mtwarning,[mbOK],0);
 edtpassword.Color:=clred;
 allcorrect:=false
end;
if allcorrect=true then  //if all is valid then inserts the database into edit

 begin
dmChess.tblregistration.Insert;
dmChess.tblregistration['first_name']:=firstname;
dmChess.tblregistration['last_name']:=lastname;
dmChess.tblregistration['birthday']:=birthdaydate;
dmChess.tblregistration['member']:=membership;
dmChess.tblregistration['email']:=email;
dmChess.tblregistration['username']:=username;
dmChess.tblregistration['password']:=result;
dmChess.tblregistration.Post;
form4.btnparticipant.Enabled:=true;
self.Close;
end;

end;

procedure TRegister_form.validation;
var flower,llower:string;
    lastlength,firstlength,comp:integer;
begin
lastlength:=length(lastname);      //gets length
firstlength:=length(firstname);
birthdaydate:=dateof(birthdaydate);  //removes time from the date
nameiscorrect:=true;//sets all of the variable
surnameiscorrect:=true;
passwordiscorrect:=true;
emailiscorrect:=true;
birthdayiscorrect:=true;
today:=now;
if firstname='' then   //check if the user has been entered
nameiscorrect:=false
else
begin
flower:=copy(firstname,2,firstlength); //converts the names into correct format
firstname:=upcase(firstname[1])+lowercase(flower);
end;
if lastname='' then //check if the user has been entered
surnameiscorrect:=false
else
begin
llower:=copy(lastname,2,lastlength);//converts the names into correct format
lastname:=upcase(lastname[1])+lowercase(llower);
end;

if not pos('@',email)=0 then  //check if email contains @
 emailiscorrect:=false;
if not pos('.',email)=0 then //check if email contains .
  emailiscorrect:=false;

if containstext('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z',firstname) then//Check that the name contains only letter
  nameiscorrect:=false;
if  containstext('A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,x,y,z',lastname) then//Check that the name contains only letter
  surnameiscorrect:=false;

comp:=comparedate(today,birthdaydate);//checks if the date occurs before today
if comp<0 then
birthdayiscorrect:=false;
if comp=0 then
birthdayiscorrect:=false;

if password='' then     //checks if the strings are blank
passwordiscorrect:=false;

if email='' then
emailiscorrect:=false;//checks if the strings are blank

end;




end.
