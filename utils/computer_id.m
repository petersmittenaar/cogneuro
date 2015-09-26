function sid = computer_id
%COMPUTER_ID Returns unique ID of the current computer as a string
%   Can be used to set computer-specific paths. Windows only.
% Peter Smittenaar, 2011. Based on
% http://undocumentedmatlab.com/blog/unique-computer-id/

sid = get(com.sun.security.auth.module.NTSystem,'DomainSID');

end

