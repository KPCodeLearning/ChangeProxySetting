#-------------------------------------------------------------------------------------------------------------------------------------------#
# Powersheet script to change proxy setting.                                                                                                #
#-------------------------------------------------------------------------------------------------------------------------------------------#
#                                                  How script works?                                                                        #
# -First thing was to find correct registry key.                                                                                            # 
# -It is under Curent User hive: HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections.                 #
# -Binary value that changes this setting is named DefaultConnectionSettings. We need to look for a value of 9th byte.                      # 
#                                                                                                                                           #
#           ##########################################################################################################################      #
#           ####                                     Meaning of value of Settings                                                 ####      #
#           #### Decimal Value|Hexadecimal Value -> Meaning                                                                       ####      # 
#           ####  1 | 01 –> All unchecked                                                                                         ####      #
#           ####  3 | 03 –> Use a Proxy Server…” (2) checked                                                                      ####      #
#           ####  9 | 09 –> “Automatically detect settings” (8) checked                                                           ####      # 
#           #### 11 | 0b (1+8+2) –> “Automatically detect settings” (8) and “Use a Proxy Server…” (2) checked                     ####      # 
#           #### 13 | 0d (1+8+4) –> “Automatically detect settings” (8) and “Use Automatic configuration script” (4) checked      ####      #    
#           #### 15 | 0f (1+8+4+2) –> All three check box are checked.                                                            ####      # 
#           ##########################################################################################################################      #
#                                                                                                                                           #
# It gets DefaultConnectionSettings value from $RegKey and store it in $Settings. Then it checks for value in 9th byte.                     #                      
# – If it’s 1 (all checkboxes are unchecked), it changes to 3 (proxy on).                                                                   #
# - If value is 3 (proxy on) then it changes to  13 (proxy unchecked and “Automatically detect settings” (8)                                #
#   and “Use Automatic configuration script” (4) checked.                                                                                   #
# – If the value is different, it changes to 3 (proxy on).                                                                                  #
#-------------------------------------------------------------------------------------------------------------------------------------------#


$RegKey = 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$Settings = (Get-ItemProperty -Path $RegKey).DefaultConnectionSettings
 
if ($Settings[8] -eq 1) {
&nbsp;&nbsp;&nbsp; $Settings[8] = 3
&nbsp;&nbsp;&nbsp; Set-ItemProperty -path $regKey -name DefaultConnectionSettings -value $Settings
&nbsp;&nbsp;&nbsp; msg console /time:3 "Proxy is now enabled"
}
 
elseif ($Settings[8] -eq 3) {
&nbsp;&nbsp;&nbsp; $Settings[8] = 13
&nbsp;&nbsp;&nbsp; Set-ItemProperty -path $regKey -name DefaultConnectionSettings -value $Settings
&nbsp;&nbsp;&nbsp; msg console /time:3 "Proxy is now disabled"
}
 
else {
&nbsp;&nbsp;&nbsp; $Settings[8] = 3
&nbsp;&nbsp;&nbsp; Set-ItemProperty -path $regKey -name DefaultConnectionSettings -value $Settings
&nbsp;&nbsp;&nbsp; msg console /time:3 "Proxy is now enabled"
}
