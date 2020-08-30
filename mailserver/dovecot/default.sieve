require ["copy","date","fileinto","relational","vacation"];
# rule:[Default]
if allof (header :contains "subject" "***SPAM***")
{
        fileinto "Junk";
}
