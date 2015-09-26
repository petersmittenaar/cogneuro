function gmail_backup_data(attachment,exp)
%% SEND_MAIL_MESSAGE send email to gmail with logfile
% Will send an email to petersmittenaardatabackup@gmail.com with the
% file(s) in the first argument 'attachment' as attachment. exp is a string
% with experiment description.
% Throws error if file is not found

% Pradyumna
% June 2008
% adapted and commented by Peter Smittenaar, 2013
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Your gmail ID and password to send e-mail from
%(from which email ID you would like to send the mail).
%Feel free to use the one I created, though keep in mind anyone can login
%and see sent e-mails (e.g. sensitive attachments, subject names, etc). 
mail = 'matlabisdone@gmail.com';    %Your GMail email address
password = 'mymatlabisdone';          %Your GMail password
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin ~= 2
    error('requires 1 string or cell, and a string, as input');
end
id = 'petersmittenaardatabackup';
message = exp;
subject = ['Datafile ' datestr(now,31) '.'];


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
sendmail(emailto,subject,message,attachment)

end
