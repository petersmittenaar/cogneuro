function send_mail_message(id,subject,message,attachment)
%% SEND_MAIL_MESSAGE send email to gmail once calculation is done
% Example
% send_mail_message('petersmittenaar','this is the subject','This is the main message','results.mat')
% will send email to petersmittenaar@gmail.com, with results.doc attached.
% It takes about 2 seconds to send the e-mail. Also, you might want to put
% it into a try-catch statement in case internet drops for whatever reason.
% Example:

% try
%     send_mail_message('petersmittenaar','script almost done','','');
% catch err
%     disp(err)
% end

% Pradyumna
% June 2008
% adapted and commented by Peter Smittenaar, 2011
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Your gmail ID and password to send e-mail from
%(from which email ID you would like to send the mail).
%Feel free to use the one I created, though keep in mind anyone can login
%and see sent e-mails (e.g. sensitive attachments, subject names, etc). 
mail = 'matlabisdone@gmail.com';    %Your GMail email address
password = 'mymatlabisdone';          %Your GMail password
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin == 0
    id = 'petersmittenaar';
    message = '';
    subject = 'Matlab is done';
    attachment = [];
elseif nargin == 1
    message = '';
    subject = 'Matlab is done';
    attachment = [];
elseif nargin == 2
    message = '';
    attachment = [];
elseif nargin == 3
    attachment = [];
end

% Send Mail ID (change this is not gmail)
emailto = strcat(id,'@gmail.com');
%% Set up Gmail SMTP service.
% Then this code will set up the preferences properly:
setpref('Internet','E_mail',mail);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',mail);
setpref('Internet','SMTP_Password',password);

% Gmail server.
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

%% Send the email
if strcmp(mail,'GmailId@gmail.com')
    disp('Please provide your own gmail.')
    disp('You can do that by modifying the first two lines of the code')
    disp('after the comments.')
end

if isempty(attachment)
    sendmail(emailto,subject,message)
else
    sendmail(emailto,subject,message)
end
end
