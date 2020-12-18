dim cookie
dim ip
dim md5

for i = 0 to WScript.Arguments.Count - 1 'do while i < WScript.Arguments.Count
    select case WScript.Arguments.Item(i)
        case "--cookie"
	    i = i + 1
	    cookie = WScript.Arguments.Item(i)
        case "--ip"
	    i = i + 1
	    ip = WScript.Arguments.Item(i)
        case "--md5"
	    i = i + 1
	    md5 = WScript.Arguments.Item(i)
    end select
next

if IsEmpty(cookie) or IsEmpty(ip) or IsEmpty(md5) then
    WScript.Echo "Parameters --cookie, --client-ip, and --md5 are required"
    WScript.Quit 1
end if

'Extract username and domain and computer from cookie

dim user
dim domain
dim computer

set regex = new RegExp
regex.Pattern = "(.+&|^)user=([^&]+)(&.+|$)"
set matches = regex.Execute(cookie)
if matches.Count > 0 then user = matches.Item(0).Submatches.Item(1)

regex.Pattern = "(.+&|^)domain=([^&]+)(&.+|$)"
set matches = regex.Execute(cookie)
if matches.Count > 0 then domain = matches.Item(0).Submatches.Item(1)

regex.Pattern = "(.+&|^)computer=([^&]+)(&.+|$)"
set matches = regex.Execute(cookie)
if matches.Count > 0 then computer = matches.Item(0).Submatches.Item(1)

'Timestamp in the format expected by GlobalProtect server
ct = now
timestamp=right("0" & month(ct), 2) & "/" & right("0" & day(ct), 2) & "/" & year(ct) & " " & right("0" & hour(ct), 2) & ":" & right("0" & minute(ct), 2) & ":" & right("0" & second(ct), 2)

'This value may need to be extracted from the official HIP report, if a made-up value is not accepted.
hostid="deadbeef-dead-beef-dead-beefdeadbeef"

report="" & _
"<hip-report name=""hip-report"">" & vbNewLine & _
"	<md5-sum>$MD5</md5-sum>" & vbNewLine & _
"	<user-name>$USER</user-name>" & vbNewLine & _
"	<domain>$DOMAIN</domain>" & vbNewLine & _
"	<host-name>$COMPUTER</host-name>" & vbNewLine & _
"	<host-id>$HOSTID</host-id>" & vbNewLine & _
"	<ip-address>$IP</ip-address>" & vbNewLine & _
"	<ipv6-address></ipv6-address>" & vbNewLine & _
"	<generate-time>$NOW</generate-time>" & vbNewLine & _
"	<categories>" & vbNewLine & _
"		<entry name=""host-info"">" & vbNewLine & _
"			<client-version>4.0.2-19</client-version>" & vbNewLine & _
"			<os>Microsoft Windows 10 Pro , 64-bit</os>" & vbNewLine & _
"			<os-vendor>Microsoft</os-vendor>" & vbNewLine & _
"			<domain>$DOMAIN.internal</domain>" & vbNewLine & _
"			<host-name>$COMPUTER</host-name>" & vbNewLine & _
"			<host-id>$HOSTID</host-id>" & vbNewLine & _
"			<network-interface>" & vbNewLine & _
"				<entry name=""{DEADBEEF-DEAD-BEEF-DEAD-BEEFDEADBEEF}"">" & vbNewLine & _
"					<description>PANGP Virtual Ethernet Adapter #2</description>" & vbNewLine & _
"					<mac-address>01-02-03-00-00-01</mac-address>" & vbNewLine & _
"					<ip-address>" & vbNewLine & _
"						<entry name=""$IP""/>" & vbNewLine & _
"					</ip-address>" & vbNewLine & _
"					<ipv6-address>" & vbNewLine & _
"						<entry name=""dead::beef:dead:beef:dead""/>" & vbNewLine & _
"					</ipv6-address>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</network-interface>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""antivirus"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""McAfee VirusScan Enterprise"" version=""8.8.0.1804"" defver=""8682.0"" prodType=""1"" engver=""5900.7806"" osType=""1"" vendor=""McAfee, Inc."" dateday=""12"" dateyear=""2017"" datemon=""10"">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<real-time-protection>yes</real-time-protection>" & vbNewLine & _
"						<last-full-scan-time>10/11/2017 15:23:41</last-full-scan-time>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Windows Defender"" version=""4.11.15063.332"" defver=""1.245.683.0"" prodType=""1"" engver=""1.1.13804.0"" osType=""1"" vendor=""Microsoft Corp."" dateday=""8"" dateyear=""2017"" datemon=""6"">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<real-time-protection>no</real-time-protection>" & vbNewLine & _
"						<last-full-scan-time>n/a</last-full-scan-time>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""anti-spyware"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""McAfee VirusScan Enterprise"" version=""8.8.0.1804"" defver=""8682.0"" prodType=""2"" engver=""5900.7806"" osType=""1"" vendor=""McAfee, Inc."" dateday=""12"" dateyear=""2017"" datemon=""10"">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<real-time-protection>yes</real-time-protection>" & vbNewLine & _
"						<last-full-scan-time>10/11/2017 15:23:41</last-full-scan-time>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Windows Defender"" version=""4.11.15063.332"" defver=""1.245.683.0"" prodType=""2"" engver=""1.1.13804.0"" osType=""1"" vendor=""Microsoft Corp."" dateday=""8"" dateyear=""2017"" datemon=""6"">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<real-time-protection>no</real-time-protection>" & vbNewLine & _
"						<last-full-scan-time>n/a</last-full-scan-time>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""disk-backup"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Windows Backup and Restore"" version=""10.0.15063.0"" vendor=""Microsoft Corp."">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<last-backup-time>n/a</last-backup-time>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""disk-encryption"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Windows Drive Encryption"" version=""10.0.15063.0"" vendor=""Microsoft Corp."">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<drives>" & vbNewLine & _
"							<entry>" & vbNewLine & _
"								<drive-name>C:</drive-name>" & vbNewLine & _
"								<enc-state>full</enc-state>" & vbNewLine & _
"							</entry>" & vbNewLine & _
"						</drives>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""firewall"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Microsoft Windows Firewall"" version=""10.0"" vendor=""Microsoft Corp."">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<is-enabled>yes</is-enabled>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""patch-management"">" & vbNewLine & _
"			<list>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""McAfee ePolicy Orchestrator Agent"" version=""5.0.5.658"" vendor=""McAfee, Inc."">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<is-enabled>yes</is-enabled>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"				<entry>" & vbNewLine & _
"					<ProductInfo>" & vbNewLine & _
"						<Prod name=""Microsoft Windows Update Agent"" version=""10.0.15063.0"" vendor=""Microsoft Corp."">" & vbNewLine & _
"						</Prod>" & vbNewLine & _
"						<is-enabled>yes</is-enabled>" & vbNewLine & _
"					</ProductInfo>" & vbNewLine & _
"				</entry>" & vbNewLine & _
"			</list>" & vbNewLine & _
"			<missing-patches/>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"		<entry name=""data-loss-prevention"">" & vbNewLine & _
"			<list/>" & vbNewLine & _
"		</entry>" & vbNewLine & _
"	</categories>" & vbNewLine & _
"</hip-report>"
report=replace(report, "$MD5", md5)
report=replace(report, "$USER", user)
report=replace(report, "$DOMAIN", domain)
report=replace(report, "$IP", ip)
report=replace(report, "$COMPUTER", computer)
report=replace(report, "$HOSTID", hostid)
report=replace(report, "$COMPUTER", computer)
report=replace(report, "$NOW", timestamp)

WScript.Echo report
