# =============================================================================
# FemDigiNomics -- Executive Insights Dashboard
# Women's Savings and Income Survey
# Author: Peter Thuo Muiruri | July 2026
# Dataset: womens_survey_raw.csv (synthetic data, n = 312)
# Framework: bs4Dash + custom navy/gold executive theme
# =============================================================================
# Run on Posit Cloud: paste into a new .R file and click "Run App"
# =============================================================================

required_pkgs <- c("shiny", "bs4Dash", "ggplot2", "dplyr", "scales")
to_install <- required_pkgs[!(required_pkgs %in% installed.packages()[, "Package"])]
if (length(to_install) > 0) install.packages(to_install)

library(shiny)
library(bs4Dash)
library(ggplot2)
library(dplyr)
library(scales)

# --- 1. Load and clean data --------------------------------------------------

csv_text <- "\"respondent_id\",\"county\",\"age_group\",\"household_size\",\"primary_income_source\",\"monthly_income_kes\",\"savings_group_member\",\"weekly_savings_kes\",\"mobile_money_access\",\"smartphone_access\",\"care_hours_per_day\",\"health_expense_kes\",\"enterprise_barrier\",\"financial_stress_score\"
\"R0001\",\"Nakuru\",\"46-55\",5,\"Self-employed\",10972,\"No\",104,\"Yes\",\"No\",4.5,3004,\"Time\",3
\"R0002\",\"Nairobi\",\"56+\",5,\"Employed\",17798,\"Yes\",1320,\"No\",\"No\",2.3,1870,\"Market access\",3
\"R0003\",\"Nairobi\",\"26-35\",5,\"Self-employed\",6450,\"Yes\",878,\"Yes\",\"No\",1.1,922,\"Market access\",3
\"R0004\",\"Embu\",\"46-55\",7,\"Casual labour\",7246,\"No\",NA,\"N/A\",\"No\",4.7,751,\"Capital\",4
\"R0005\",\"Nairobi\",\"18-25\",6,\"Employed\",26167,\"Yes\",975,\"Yes\",\"No\",2.8,6702,\"Time\",4
\"R0006\",\"Mombasa\",\"36-45\",4,\"Casual labour\",7150,\"No\",103,\"No\",\"Yes\",3,456,\"Market access\",3
\"R0007\",\"Embu\",\"18-25\",4,\"Self-employed\",9029,\"No\",272,\"No\",\"No\",0.9,2069,\"Market access\",1
\"R0008\",\"Embu\",\"26-35\",1,\"Self-employed\",12509,\"Yes\",686,\"Yes\",\"No\",4.9,3104,\"Capital\",2
\"R0009\",\"Nakuru\",\"18-25\",5,\"Self-employed\",10558,\"No\",142,\"Yes\",\"No\",3.4,1477,\"Capital\",1
\"R0010\",\"Nakuru\",\"18-25\",1,\"Self-employed\",20399,\"Yes\",628,\"No\",\"No\",7.7,1345,\"Capital\",1
\"R0011\",\"Nairobi\",\"36-45\",3,\"Casual labour\",5430,\"Yes\",NA,\"No\",\"Yes\",0.9,1238,\"Capital\",4
\"R0012\",\"Nairobi\",\"18-25\",4,\"Employed\",24378,\"No\",230,\"No\",\"Yes\",6.3,2252,\"Capital\",4
\"R0013\",\"Mombasa\",\"56+\",4,\"Self-employed\",16190,\"No\",81,\"N/A\",\"No\",5.6,1603,\"Capital\",4
\"R0014\",\"Embu\",\"26-35\",9,\"Casual labour\",7332,\"No\",118,\"No\",\"Yes\",8,844,\"Capital\",3
\"R0015\",\"Nakuru\",\"36-45\",1,\"Employed\",13365,\"Yes\",NA,\"Yes\",\"Yes\",3.6,1273,\"Capital\",4
\"R0016\",\"Kisumu\",\"56+\",4,\"Employed\",13182,\"Yes\",946,\"Yes\",\"No\",3,3990,\"Skills\",5
\"R0017\",\"Kisumu\",\"56+\",3,\"Self-employed\",1682,\"No\",120,\"yes\",\"No\",4.1,369,\"Time\",3
\"R0018\",\"Kisumu\",\"26-35\",3,\"Self-employed\",6568,\"Yes\",831,\"No\",\"No\",NA,1294,\"None\",3
\"R0019\",\"Embu\",\"36-45\",4,\"Casual labour\",NA,\"No\",170,\"Yes\",\"Yes\",5.5,620,\"Market access\",4
\"R0020\",\"Nairobi\",\"36-45\",5,\"Employed\",12646,\"Yes\",1453,\"No\",\"Yes\",4.7,3213,\"None\",4
\"R0021\",\"Nairobi\",\"46-55\",5,\"Casual labour\",7400,\"Yes\",1111,\"No\",\"No\",5.6,656,\"Capital\",3
\"R0022\",\"Nakuru\",\"26-35\",1,\"Employed\",25375,\"Yes\",917,\"No\",\"No\",NA,3887,\"None\",3
\"R0023\",\"Mombasa\",\"56+\",5,\"Casual labour\",6799,\"No\",113,\"Yes\",\"Yes\",7.1,1756,\"Time\",4
\"R0024\",\"Nakuru\",\"56+\",4,\"Self-employed\",11093,\"Yes\",759,\"\",\"Yes\",3.8,1057,\"Capital\",5
\"R0025\",\"Mombasa\",\"26-35\",5,\"None\",621,\"YES\",1378,\"No\",\"No\",6,107,\"Capital\",4
\"R0026\",\"Nairobi\",\"36-45\",5,\"None\",1274,\"No\",24,\"N/A\",\"No\",9.2,138,\"Capital\",4
\"R0027\",\"Kisumu\",\"36-45\",6,\"Self-employed\",9962,\"No\",147,\"yes\",\"Yes\",4.1,NA,\"Skills\",3
\"R0028\",\"Nairobi\",\"46-55\",4,\"None\",1175,\"Yes\",980,\"Yes\",\"Yes\",4.3,195,\"Capital\",4
\"R0029\",\"Nakuru\",\"36-45\",2,\"Employed\",27392,\"Yes\",983,\"Yes\",\"Yes\",3.8,4243,\"Time\",4
\"R0030\",\"Nairobi\",\"46-55\",2,\"Employed\",14864,\"Yes\",931,\"No\",\"No\",5.6,3675,\"Skills\",5
\"R0031\",\"Kisumu\",\"18-25\",3,\"Casual labour\",9206,\"No\",26,\"Yes\",\"No\",3.6,2026,\"Capital\",3
\"R0032\",\"Nakuru\",\"46-55\",6,\"Casual labour\",5443,\"No\",206,\"Yes\",\"No\",3,1281,\"Capital\",5
\"R0033\",\"Nairobi\",\"36-45\",4,\"Self-employed\",16547,\"No\",319,\"No\",\"No\",4.8,3933,\"Time\",4
\"R0034\",\"Nairobi\",\"18-25\",3,\"Self-employed\",13006,\"Yes\",1030,\"Yes\",\"No\",4.2,3597,\"Capital\",4
\"R0035\",\"Embu\",\"26-35\",6,\"Casual labour\",5359,\"yes\",801,\"No\",\"Yes\",7.4,1008,\"Capital\",4
\"R0036\",\"Nakuru\",\"46-55\",4,\"Self-employed\",7704,\"Yes\",1085,\"Yes\",\"Yes\",5,1712,\"Capital\",4
\"R0037\",\"Kisumu\",\"26-35\",5,\"Employed\",17679,\"Yes\",558,\"Yes\",\"Yes\",3.4,2524,\"Time\",4
\"R0038\",\"Embu\",\"26-35\",4,\"None\",2122,\"Yes\",754,\"Yes\",\"No\",5.1,341,\"Capital\",4
\"R0039\",\"Nakuru\",\"46-55\",5,\"Self-employed\",6690,\"yes\",1106,\"Yes\",\"Yes\",2.2,1424,\"Market access\",4
\"R0040\",\"Mombasa\",\"18-25\",3,\"Employed\",16198,\"Yes\",NA,\"\",\"No\",2.3,2316,\"Time\",5
\"R0041\",\"Nairobi\",\"36-45\",4,\"Self-employed\",508,\"No\",124,\"Yes\",\"No\",5.2,71,\"Capital\",2
\"R0042\",\"Nairobi\",\"36-45\",4,\"Employed\",27017,\"Yes\",787,\"Yes\",\"Yes\",3.5,5182,\"Capital\",5
\"R0043\",\"Kisumu\",\"26-35\",1,\"Casual labour\",5597,\"Yes\",1040,\"Yes\",\"No\",7.5,1639,\"Market access\",5
\"R0044\",\"Nakuru\",\"56+\",9,\"Casual labour\",4910,\"Yes\",975,\"No\",\"No\",5.4,288,\"Market access\",3
\"R0045\",\"Mombasa\",\"36-45\",5,\"Employed\",15226,\"Yes\",1229,\"Yes\",\"Yes\",3.1,2014,\"Capital\",5
\"R0046\",\"Embu\",\"56+\",4,\"Self-employed\",15341,\"No\",NA,\"No\",\"No\",5,3076,\"Capital\",3
\"R0047\",\"Nakuru\",\"46-55\",8,\"Casual labour\",6972,\"Yes\",912,\"\",\"No\",4.8,1363,\"Capital\",3
\"R0048\",\"Nakuru\",\"18-25\",3,\"Employed\",34248,\"Yes\",1283,\"No\",\"No\",2.5,1946,\"Skills\",4
\"R0049\",\"Mombasa\",\"56+\",4,\"Self-employed\",12422,\"Yes\",NA,\"No\",\"Yes\",2.5,NA,\"None\",5
\"R0050\",\"Mombasa\",\"18-25\",5,\"Casual labour\",8627,\"No\",160,\"No\",\"No\",3.8,692,\"Time\",1
\"R0051\",\"Nairobi\",\"36-45\",6,\"Self-employed\",11941,\"Yes\",1002,\"Yes\",\"Yes\",1.2,1986,\"Capital\",2
\"R0052\",\"Embu\",\"36-45\",5,\"Self-employed\",NA,\"No\",34,\"Yes\",\"Yes\",4.4,1375,\"Market access\",3
\"R0053\",\"Mombasa\",\"36-45\",2,\"Self-employed\",-999,\"Yes\",916,\"No\",\"No\",1.6,NA,\"Time\",5
\"R0054\",\"Mombasa\",\"46-55\",3,\"Self-employed\",15492,\"No\",115,\"Yes\",\"No\",3.1,2632,\"Capital\",4
\"R0055\",\"Mombasa\",\"26-35\",6,\"Self-employed\",2952,\"No\",59,\"No\",\"Yes\",1.8,452,\"Market access\",4
\"R0056\",\"Embu\",\"18-25\",6,\"Self-employed\",6923,\"yes\",521,\"Yes\",\"Yes\",6.8,2425,\"Skills\",3
\"R0057\",\"Nakuru\",\"18-25\",3,\"Casual labour\",10946,\"Yes\",1263,\"No\",\"Yes\",7.3,1330,\"Capital\",5
\"R0058\",\"Nairobi\",\"26-35\",4,\"Employed\",27523,\"No\",213,\"Yes\",\"No\",4.3,4930,\"Time\",5
\"R0059\",\"Nairobi\",\"26-35\",4,\"Employed\",14761,\"Yes\",1225,\"Yes\",\"No\",5.3,2114,\"Time\",3
\"R0060\",\"Nakuru\",\"36-45\",4,\"None\",128,\"Yes\",NA,\"No\",\"No\",7.7,12,\"Capital\",1
\"R0061\",\"Kisumu\",\"18-25\",3,\"Self-employed\",15258,\"No\",75,\"No\",\"No\",NA,3333,\"Capital\",3
\"R0062\",\"Nairobi\",\"56+\",2,\"Employed\",10594,\"Yes\",743,\"Yes\",\"No\",2.6,1358,\"None\",5
\"R0063\",\"Kisumu\",\"18-25\",2,\"Self-employed\",6991,\"No\",172,\"No\",\"No\",5.1,1664,\"Skills\",5
\"R0064\",\"Embu\",\"36-45\",8,\"Self-employed\",10457,\"No\",282,\"Yes\",\"Yes\",3.1,1436,\"Capital\",4
\"R0065\",\"Nairobi\",\"46-55\",7,\"Employed\",19912,\"No\",28,\"No\",\"Yes\",4.6,3159,\"Market access\",4
\"R0066\",\"Nairobi\",\"26-35\",2,\"Casual labour\",7007,\"No\",NA,\"No\",\"Yes\",7.6,735,\"Capital\",3
\"R0067\",\"Nairobi\",\"26-35\",5,\"Casual labour\",-999,\"Yes\",666,\"Yes\",\"Yes\",5.5,NA,\"Capital\",1
\"R0068\",\"Kisumu\",\"46-55\",6,\"Self-employed\",6392,\"Yes\",1094,\"Yes\",\"No\",6.8,920,\"Time\",3
\"R0069\",\"Mombasa\",\"18-25\",3,\"Employed\",21612,\"No\",104,\"No\",\"No\",3.9,4328,\"None\",5
\"R0070\",\"Nakuru\",\"26-35\",3,\"Employed\",17769,\"Yes\",1246,\"Yes\",\"No\",3.7,186,\"Market access\",5
\"R0071\",\"Nakuru\",\"26-35\",4,\"Self-employed\",7354,\"No\",186,\"Yes\",\"No\",4.9,662,\"Capital\",2
\"R0072\",\"Nairobi\",\"26-35\",3,\"Employed\",15421,\"Yes\",1363,\"Yes\",\"No\",4.1,2972,\"Market access\",2
\"R0073\",\"Mombasa\",\"26-35\",3,\"Casual labour\",7194,\"yes\",309,\"Yes\",\"No\",7.1,589,\"Capital\",4
\"R0074\",\"Kisumu\",\"36-45\",4,\"None\",1516,\"No\",216,\"yes\",\"No\",10.9,377,\"Capital\",3
\"R0075\",\"Nairobi\",\"26-35\",5,\"None\",1241,\"No\",150,\"Yes\",\"Yes\",7.5,110,\"Capital\",3
\"R0076\",\"Embu\",\"18-25\",6,\"Casual labour\",4899,\"Yes\",524,\"Yes\",\"Yes\",6,494,\"Market access\",4
\"R0077\",\"Nairobi\",\"26-35\",5,\"Employed\",NA,\"Yes\",1248,\"yes\",\"Yes\",3,759,\"Capital\",2
\"R0078\",\"Nairobi\",\"36-45\",5,\"Casual labour\",7868,\"No\",118,\"Yes\",\"Yes\",5.5,1166,\"Time\",2
\"R0079\",\"Embu\",\"36-45\",6,\"Self-employed\",17346,\"Yes\",799,\"No\",\"No\",3.1,2597,\"Skills\",4
\"R0080\",\"Mombasa\",\"26-35\",6,\"Employed\",18252,\"No\",117,\"No\",\"No\",3.7,3710,\"None\",1
\"R0081\",\"Mombasa\",\"18-25\",2,\"Employed\",-999,\"Yes\",858,\"No\",\"Yes\",6,NA,\"Capital\",3
\"R0082\",\"Nairobi\",\"26-35\",1,\"Employed\",-999,\"No\",167,\"No\",\"Yes\",4.8,NA,\"Capital\",3
\"R0083\",\"Kisumu\",\"36-45\",6,\"Self-employed\",13256,\"Yes\",974,\"Yes\",\"Yes\",5,2861,\"Market access\",4
\"R0084\",\"Nakuru\",\"18-25\",3,\"Self-employed\",NA,\"No\",35,\"Yes\",\"No\",4.6,123,\"Time\",2
\"R0085\",\"Embu\",\"46-55\",5,\"Self-employed\",11942,\"Yes\",802,\"yes\",\"Yes\",0.5,2941,\"Time\",5
\"R0086\",\"Embu\",\"36-45\",6,\"Casual labour\",10155,\"No\",50,\"Yes\",\"Yes\",4.4,2818,\"Capital\",2
\"R0087\",\"Mombasa\",\"26-35\",6,\"None\",-999,\"No\",42,\"Yes\",\"No\",6.9,NA,\"Market access\",5
\"R0088\",\"Nairobi\",\"26-35\",5,\"Employed\",23806,\"Yes\",NA,\"Yes\",\"No\",1.6,2610,\"Market access\",2
\"R0089\",\"Nairobi\",\"26-35\",5,\"Casual labour\",7843,\"No\",32,\"Yes\",\"No\",6.1,149,\"Time\",4
\"R0090\",\"Nakuru\",\"36-45\",1,\"Employed\",12847,\"Yes\",1051,\"Yes\",\"No\",1.8,499,\"Capital\",3
\"R0091\",\"Mombasa\",\"18-25\",8,\"Employed\",27464,\"No\",139,\"Yes\",\"Yes\",NA,466,\"Time\",4
\"R0092\",\"Nakuru\",\"26-35\",1,\"Employed\",12523,\"No\",NA,\"Yes\",\"Yes\",3.8,2438,\"Capital\",5
\"R0093\",\"Embu\",\"26-35\",3,\"Casual labour\",4634,\"Yes\",988,\"Yes\",\"No\",4.9,1023,\"Time\",3
\"R0094\",\"Nairobi\",\"56+\",2,\"Self-employed\",11293,\"No\",194,\"No\",\"Yes\",3.6,3251,\"Capital\",2
\"R0095\",\"Embu\",\"56+\",5,\"Self-employed\",12454,\"Yes\",416,\"\",\"No\",4.9,2440,\"Capital\",4
\"R0096\",\"Nairobi\",\"18-25\",2,\"Employed\",22473,\"Yes\",1427,\"Yes\",\"Yes\",3.1,5481,\"Time\",1
\"R0097\",\"Nairobi\",\"36-45\",4,\"Self-employed\",8311,\"No\",104,\"No\",\"Yes\",4.3,NA,\"Time\",5
\"R0098\",\"Nakuru\",\"36-45\",6,\"Casual labour\",2378,\"No\",98,\"No\",\"No\",6,215,\"Market access\",5
\"R0099\",\"Nairobi\",\"18-25\",3,\"Self-employed\",16326,\"Yes\",960,\"Yes\",\"No\",1.8,3125,\"Capital\",3
\"R0100\",\"Mombasa\",\"18-25\",6,\"Self-employed\",8023,\"No\",158,\"No\",\"Yes\",3.1,1580,\"Time\",3
\"R0101\",\"Nairobi\",\"18-25\",6,\"Self-employed\",7950,\"Yes\",827,\"Yes\",\"No\",4.5,33,\"Capital\",2
\"R0102\",\"Kisumu\",\"26-35\",6,\"Employed\",20134,\"Yes\",885,\"Yes\",\"No\",5.7,4934,\"Capital\",4
\"R0103\",\"Nairobi\",\"26-35\",6,\"Self-employed\",20591,\"Yes\",1171,\"Yes\",\"Yes\",2.6,2491,\"Market access\",4
\"R0104\",\"Nairobi\",\"36-45\",3,\"Casual labour\",9437,\"No\",76,\"Yes\",\"Yes\",5.2,1520,\"Market access\",3
\"R0105\",\"Nairobi\",\"56+\",3,\"Casual labour\",4747,\"Yes\",641,\"Yes\",\"No\",7,422,\"Market access\",5
\"R0106\",\"Kisumu\",\"56+\",5,\"Casual labour\",4047,\"No\",22,\"Yes\",\"Yes\",6.6,894,\"Market access\",5
\"R0107\",\"Nakuru\",\"18-25\",4,\"Casual labour\",7176,\"Yes\",1244,\"No\",\"No\",3.4,1007,\"Capital\",4
\"R0108\",\"Nairobi\",\"18-25\",5,\"None\",NA,\"No\",220,\"Yes\",\"Yes\",8.7,281,\"None\",5
\"R0109\",\"Nairobi\",\"36-45\",3,\"None\",NA,\"Yes\",1025,\"Yes\",\"Yes\",7.6,966,\"Skills\",5
\"R0110\",\"Nakuru\",\"26-35\",6,\"None\",2232,\"No\",90,\"yes\",\"No\",7.2,85,\"Capital\",4
\"R0111\",\"Embu\",\"18-25\",2,\"Self-employed\",11137,\"Yes\",756,\"yes\",\"Yes\",4.5,1724,\"Capital\",3
\"R0112\",\"Kisumu\",\"46-55\",5,\"Casual labour\",7259,\"No\",128,\"Yes\",\"No\",7.1,1245,\"Time\",3
\"R0113\",\"Mombasa\",\"18-25\",6,\"Self-employed\",11007,\"No\",195,\"Yes\",\"Yes\",3.1,4250,\"Time\",4
\"R0114\",\"Nairobi\",\"36-45\",4,\"Employed\",19391,\"Yes\",464,\"Yes\",\"No\",3.5,4089,\"Market access\",4
\"R0115\",\"Nakuru\",\"36-45\",6,\"Casual labour\",1642,\"Yes\",1335,\"Yes\",\"No\",5.8,112,\"Market access\",3
\"R0116\",\"Nakuru\",\"36-45\",2,\"Employed\",14418,\"Yes\",676,\"Yes\",\"Yes\",3.5,2885,\"Skills\",5
\"R0117\",\"Mombasa\",\"26-35\",6,\"None\",1101,\"Yes\",854,\"Yes\",\"No\",5.6,178,\"Time\",5
\"R0118\",\"Nakuru\",\"36-45\",6,\"Casual labour\",5359,\"Yes\",1489,\"Yes\",\"No\",3.6,1006,\"Market access\",3
\"R0119\",\"Nakuru\",\"18-25\",4,\"Casual labour\",4271,\"No\",256,\"No\",\"Yes\",5.5,174,\"Capital\",5
\"R0120\",\"Mombasa\",\"46-55\",5,\"None\",1427,\"No\",23,\"Yes\",\"No\",6.4,434,\"Market access\",2
\"R0121\",\"Nakuru\",\"36-45\",2,\"None\",2283,\"Yes\",332,\"No\",\"Yes\",6,490,\"Market access\",5
\"R0122\",\"Nairobi\",\"36-45\",5,\"Casual labour\",8656,\"Yes\",430,\"yes\",\"No\",5.4,1211,\"Market access\",5
\"R0123\",\"Embu\",\"36-45\",5,\"Self-employed\",12434,\"Yes\",540,\"Yes\",\"No\",2.3,97,\"Capital\",3
\"R0124\",\"Nairobi\",\"18-25\",6,\"Employed\",22912,\"Yes\",NA,\"Yes\",\"Yes\",4.7,4624,\"Market access\",2
\"R0125\",\"Nakuru\",\"18-25\",9,\"None\",NA,\"Yes\",NA,\"yes\",\"No\",10,291,\"Market access\",2
\"R0126\",\"Nairobi\",\"36-45\",8,\"Self-employed\",NA,\"Yes\",875,\"No\",\"Yes\",6.4,377,\"Market access\",5
\"R0127\",\"Nairobi\",\"46-55\",4,\"Self-employed\",12364,\"No\",319,\"No\",\"No\",3.6,2638,\"Capital\",1
\"R0128\",\"Nakuru\",\"56+\",7,\"Self-employed\",12496,\"Yes\",777,\"Yes\",\"No\",5.8,2859,\"Market access\",4
\"R0129\",\"Mombasa\",\"26-35\",5,\"Casual labour\",7377,\"Yes\",1084,\"Yes\",\"Yes\",5.5,1031,\"Time\",4
\"R0130\",\"Embu\",\"18-25\",5,\"Self-employed\",4990,\"Yes\",961,\"No\",\"Yes\",1.9,192,\"Market access\",4
\"R0131\",\"Nakuru\",\"46-55\",6,\"Self-employed\",12973,\"Yes\",838,\"Yes\",\"Yes\",4.6,237,\"Time\",5
\"R0132\",\"Embu\",\"18-25\",9,\"Self-employed\",12844,\"Yes\",894,\"Yes\",\"No\",0.7,745,\"Time\",3
\"R0133\",\"Nairobi\",\"18-25\",3,\"Casual labour\",1591,\"Yes\",474,\"yes\",\"No\",4.8,182,\"Capital\",5
\"R0134\",\"Nakuru\",\"56+\",1,\"Self-employed\",14356,\"Yes\",1348,\"No\",\"No\",0,1322,\"Capital\",1
\"R0135\",\"Nairobi\",\"46-55\",5,\"None\",2037,\"Yes\",940,\"No\",\"No\",6,399,\"Capital\",4
\"R0136\",\"Kisumu\",\"36-45\",6,\"None\",1389,\"No\",90,\"yes\",\"Yes\",7.1,145,\"Capital\",5
\"R0137\",\"Mombasa\",\"46-55\",7,\"None\",501,\"No\",108,\"Yes\",\"No\",5,104,\"Market access\",5
\"R0138\",\"Nairobi\",\"26-35\",6,\"Employed\",31384,\"Yes\",656,\"yes\",\"No\",4.6,8337,\"Market access\",5
\"R0139\",\"Nakuru\",\"46-55\",7,\"Self-employed\",13225,\"Yes\",1192,\"No\",\"Yes\",4,1777,\"Market access\",3
\"R0140\",\"Nakuru\",\"18-25\",5,\"Self-employed\",8878,\"Yes\",898,\"No\",\"No\",6.2,548,\"Capital\",5
\"R0141\",\"Mombasa\",\"26-35\",8,\"Employed\",18930,\"Yes\",503,\"Yes\",\"Yes\",1.5,1423,\"Capital\",5
\"R0142\",\"Mombasa\",\"26-35\",6,\"Employed\",10496,\"No\",132,\"Yes\",\"No\",0,2423,\"None\",2
\"R0143\",\"Nakuru\",\"36-45\",5,\"None\",1164,\"No\",200,\"No\",\"No\",8.3,53,\"Capital\",3
\"R0144\",\"Nairobi\",\"46-55\",2,\"Casual labour\",9698,\"No\",52,\"Yes\",\"Yes\",6.3,2892,\"None\",1
\"R0145\",\"Nairobi\",\"18-25\",4,\"Casual labour\",5937,\"No\",299,\"Yes\",\"Yes\",4.4,1142,\"Time\",3
\"R0146\",\"Mombasa\",\"46-55\",3,\"Casual labour\",6400,\"No\",0,\"No\",\"No\",6.9,1579,\"Market access\",2
\"R0147\",\"Embu\",\"26-35\",2,\"Casual labour\",6820,\"YES\",991,\"No\",\"No\",6.1,757,\"Capital\",4
\"R0148\",\"Kisumu\",\"56+\",6,\"Self-employed\",10883,\"Yes\",912,\"Yes\",\"No\",2.2,1292,\"Market access\",2
\"R0149\",\"Nakuru\",\"26-35\",6,\"Casual labour\",7932,\"Yes\",544,\"Yes\",\"No\",3.7,1632,\"Capital\",4
\"R0150\",\"Nairobi\",\"26-35\",4,\"Self-employed\",15801,\"Yes\",885,\"yes\",\"Yes\",2.6,2447,\"Capital\",2
\"R0151\",\"Kisumu\",\"18-25\",7,\"Employed\",24118,\"Yes\",1000,\"No\",\"No\",3.5,NA,\"Skills\",4
\"R0152\",\"Nairobi\",\"36-45\",7,\"Self-employed\",16112,\"Yes\",895,\"Yes\",\"No\",4.1,2497,\"Market access\",2
\"R0153\",\"Nairobi\",\"46-55\",6,\"None\",1906,\"No\",302,\"Yes\",\"Yes\",7.7,296,\"None\",3
\"R0154\",\"Mombasa\",\"36-45\",3,\"None\",1515,\"YES\",1417,\"Yes\",\"No\",NA,471,\"Skills\",2
\"R0155\",\"Nakuru\",\"18-25\",4,\"Employed\",NA,\"Yes\",1090,\"No\",\"Yes\",5,1047,\"Capital\",5
\"R0156\",\"Nairobi\",\"46-55\",4,\"None\",1979,\"Yes\",293,\"yes\",\"No\",3.9,32,\"Time\",4
\"R0157\",\"Nakuru\",\"26-35\",5,\"Casual labour\",5972,\"Yes\",1197,\"No\",\"No\",6.2,1358,\"Time\",3
\"R0158\",\"Embu\",\"26-35\",5,\"Casual labour\",6565,\"Yes\",612,\"No\",\"Yes\",7.4,758,\"Market access\",4
\"R0159\",\"Nakuru\",\"26-35\",6,\"Casual labour\",3397,\"Yes\",358,\"Yes\",\"No\",6.9,588,\"Market access\",5
\"R0160\",\"Nairobi\",\"18-25\",6,\"Self-employed\",2388,\"Yes\",953,\"No\",\"No\",4.5,665,\"Skills\",3
\"R0161\",\"Embu\",\"56+\",1,\"Employed\",24208,\"Yes\",911,\"Yes\",\"No\",6.3,7391,\"Capital\",4
\"R0162\",\"Embu\",\"36-45\",2,\"Self-employed\",6991,\"yes\",845,\"Yes\",\"No\",3.8,83,\"None\",3
\"R0163\",\"Nakuru\",\"18-25\",2,\"Self-employed\",17584,\"Yes\",674,\"Yes\",\"No\",3.1,843,\"Capital\",1
\"R0164\",\"Nakuru\",\"26-35\",4,\"Casual labour\",6584,\"Yes\",NA,\"Yes\",\"Yes\",8.2,1350,\"Capital\",1
\"R0165\",\"Mombasa\",\"36-45\",5,\"Casual labour\",8993,\"No\",178,\"Yes\",\"Yes\",6.2,1066,\"Market access\",3
\"R0166\",\"Embu\",\"26-35\",3,\"Self-employed\",14501,\"Yes\",540,\"Yes\",\"No\",1.5,1913,\"Time\",5
\"R0167\",\"Nairobi\",\"36-45\",5,\"Employed\",30356,\"Yes\",441,\"Yes\",\"Yes\",2.1,8146,\"None\",3
\"R0168\",\"Kisumu\",\"36-45\",3,\"Casual labour\",7436,\"No\",138,\"No\",\"No\",6.9,990,\"Skills\",2
\"R0169\",\"Nairobi\",\"26-35\",1,\"Employed\",NA,\"YES\",826,\"\",\"No\",6.2,383,\"Capital\",2
\"R0170\",\"Mombasa\",\"26-35\",5,\"Self-employed\",10462,\"No\",162,\"No\",\"No\",4.1,1527,\"Capital\",3
\"R0171\",\"Kisumu\",\"18-25\",4,\"Casual labour\",9539,\"No\",90,\"Yes\",\"No\",NA,2209,\"Capital\",4
\"R0172\",\"Nairobi\",\"36-45\",4,\"Self-employed\",20079,\"Yes\",1189,\"Yes\",\"No\",1.8,3799,\"Market access\",5
\"R0173\",\"Embu\",\"36-45\",4,\"Casual labour\",4438,\"Yes\",909,\"Yes\",\"Yes\",6.4,1022,\"Capital\",5
\"R0174\",\"Nakuru\",\"36-45\",4,\"Self-employed\",6815,\"No\",86,\"Yes\",\"No\",0.4,194,\"Capital\",3
\"R0175\",\"Embu\",\"36-45\",6,\"Employed\",10431,\"Yes\",NA,\"Yes\",\"No\",3.9,1870,\"Capital\",4
\"R0176\",\"Nairobi\",\"26-35\",3,\"Self-employed\",14379,\"Yes\",918,\"No\",\"No\",1.9,3240,\"Capital\",3
\"R0177\",\"Nairobi\",\"46-55\",5,\"None\",889,\"No\",30,\"Yes\",\"No\",7.8,249,\"Capital\",4
\"R0178\",\"Nairobi\",\"18-25\",4,\"None\",418,\"No\",80,\"Yes\",\"Yes\",6,20,\"Capital\",1
\"R0179\",\"Embu\",\"46-55\",3,\"Self-employed\",17848,\"No\",177,\"Yes\",\"No\",4.7,1917,\"Capital\",4
\"R0180\",\"Nakuru\",\"46-55\",4,\"Casual labour\",6288,\"yes\",1777,\"No\",\"Yes\",6.1,1475,\"Capital\",5
\"R0181\",\"Kisumu\",\"46-55\",4,\"Casual labour\",5295,\"Yes\",63,\"Yes\",\"No\",6.9,1122,\"Capital\",4
\"R0182\",\"Nakuru\",\"46-55\",2,\"Self-employed\",12735,\"Yes\",1301,\"Yes\",\"Yes\",3.7,2528,\"Capital\",5
\"R0183\",\"Nakuru\",\"36-45\",3,\"Casual labour\",2581,\"No\",0,\"Yes\",\"No\",6.8,107,\"Capital\",5
\"R0184\",\"Nairobi\",\"26-35\",5,\"Self-employed\",NA,\"No\",148,\"\",\"Yes\",3.6,721,\"Skills\",3
\"R0185\",\"Kisumu\",\"18-25\",4,\"Self-employed\",13834,\"Yes\",1145,\"No\",\"Yes\",3.3,40,\"Market access\",3
\"R0186\",\"Nairobi\",\"18-25\",6,\"Casual labour\",9230,\"Yes\",737,\"Yes\",\"No\",5.7,1583,\"Capital\",4
\"R0187\",\"Nairobi\",\"46-55\",5,\"Self-employed\",19677,\"No\",102,\"Yes\",\"No\",1,1782,\"Capital\",4
\"R0188\",\"Nairobi\",\"46-55\",7,\"None\",2108,\"Yes\",1165,\"yes\",\"No\",10.1,116,\"Market access\",3
\"R0189\",\"Nairobi\",\"26-35\",4,\"Casual labour\",6582,\"Yes\",537,\"No\",\"No\",9.1,1208,\"Market access\",2
\"R0190\",\"Nairobi\",\"26-35\",3,\"Casual labour\",4863,\"No\",100,\"Yes\",\"Yes\",5.8,1537,\"Capital\",4
\"R0191\",\"Nakuru\",\"26-35\",7,\"Employed\",14262,\"No\",229,\"Yes\",\"Yes\",NA,617,\"Capital\",4
\"R0192\",\"Kisumu\",\"46-55\",3,\"Casual labour\",7180,\"No\",71,\"yes\",\"No\",6.5,719,\"Capital\",3
\"R0193\",\"Nairobi\",\"26-35\",8,\"None\",731,\"Yes\",1270,\"yes\",\"No\",NA,113,\"Time\",5
\"R0194\",\"Embu\",\"26-35\",5,\"Self-employed\",19798,\"No\",170,\"Yes\",\"No\",3.4,2246,\"Market access\",4
\"R0195\",\"Mombasa\",\"26-35\",4,\"Self-employed\",20705,\"Yes\",1022,\"No\",\"No\",NA,1791,\"Skills\",5
\"R0196\",\"Nairobi\",\"26-35\",5,\"Casual labour\",4241,\"Yes\",946,\"Yes\",\"No\",6.8,928,\"None\",2
\"R0197\",\"Embu\",\"36-45\",5,\"Self-employed\",15238,\"Yes\",971,\"yes\",\"No\",1.8,1363,\"Capital\",4
\"R0198\",\"Nairobi\",\"26-35\",4,\"Casual labour\",6046,\"No\",91,\"No\",\"No\",4.5,950,\"Capital\",1
\"R0199\",\"Nairobi\",\"18-25\",4,\"Self-employed\",11919,\"Yes\",881,\"Yes\",\"No\",3.3,2961,\"Market access\",5
\"R0200\",\"Kisumu\",\"18-25\",6,\"Self-employed\",NA,\"No\",167,\"Yes\",\"No\",1.8,995,\"Time\",4
\"R0201\",\"Nairobi\",\"46-55\",1,\"Self-employed\",15423,\"Yes\",895,\"No\",\"Yes\",3.3,641,\"Capital\",4
\"R0202\",\"Nairobi\",\"36-45\",4,\"None\",2928,\"Yes\",1145,\"Yes\",\"No\",6.2,805,\"Capital\",4
\"R0203\",\"Nakuru\",\"46-55\",6,\"Self-employed\",16545,\"Yes\",690,\"Yes\",\"No\",2.7,NA,\"Capital\",2
\"R0204\",\"Nakuru\",\"36-45\",6,\"Self-employed\",9179,\"Yes\",417,\"No\",\"No\",4.7,1721,\"Capital\",3
\"R0205\",\"Nairobi\",\"26-35\",3,\"Self-employed\",4644,\"No\",144,\"Yes\",\"No\",5.1,741,\"Skills\",2
\"R0206\",\"Nairobi\",\"36-45\",4,\"Self-employed\",17604,\"Yes\",262,\"No\",\"No\",3.7,1774,\"Time\",3
\"R0207\",\"Nakuru\",\"56+\",2,\"Self-employed\",12816,\"No\",229,\"Yes\",\"No\",5.2,1332,\"Market access\",3
\"R0208\",\"Mombasa\",\"36-45\",3,\"Casual labour\",7885,\"No\",170,\"Yes\",\"No\",6.4,739,\"Capital\",5
\"R0209\",\"Kisumu\",\"26-35\",5,\"Self-employed\",16120,\"No\",76,\"No\",\"No\",4.6,945,\"Capital\",1
\"R0210\",\"Embu\",\"26-35\",1,\"Self-employed\",16718,\"No\",163,\"Yes\",\"No\",4.7,3554,\"Capital\",2
\"R0211\",\"Kisumu\",\"36-45\",3,\"Casual labour\",-999,\"No\",203,\"Yes\",\"No\",5.2,NA,\"Capital\",5
\"R0212\",\"Nairobi\",\"18-25\",6,\"Casual labour\",7518,\"No\",173,\"No\",\"Yes\",5.4,460,\"Skills\",4
\"R0213\",\"Mombasa\",\"36-45\",3,\"Self-employed\",10333,\"No\",106,\"Yes\",\"Yes\",4.1,2102,\"None\",5
\"R0214\",\"Mombasa\",\"26-35\",5,\"Employed\",14031,\"Yes\",737,\"yes\",\"Yes\",3.3,1431,\"Market access\",5
\"R0215\",\"Nairobi\",\"36-45\",5,\"None\",376,\"Yes\",1031,\"No\",\"No\",5.3,90,\"Time\",5
\"R0216\",\"Embu\",\"46-55\",6,\"Self-employed\",14623,\"No\",177,\"No\",\"No\",2,3696,\"None\",4
\"R0217\",\"Nakuru\",\"36-45\",4,\"Employed\",29200,\"Yes\",815,\"No\",\"No\",1.1,5012,\"Capital\",2
\"R0218\",\"Nairobi\",\"36-45\",4,\"Employed\",19150,\"Yes\",547,\"Yes\",\"No\",2.6,3861,\"None\",4
\"R0219\",\"Embu\",\"36-45\",5,\"Self-employed\",5849,\"YES\",58,\"No\",\"No\",4.5,1124,\"Time\",4
\"R0220\",\"Nairobi\",\"46-55\",5,\"Casual labour\",8032,\"No\",293,\"Yes\",\"No\",7,461,\"Market access\",5
\"R0221\",\"Kisumu\",\"36-45\",1,\"Casual labour\",8165,\"Yes\",389,\"N/A\",\"No\",7.7,1914,\"Skills\",5
\"R0222\",\"Mombasa\",\"26-35\",5,\"Self-employed\",14359,\"No\",99,\"Yes\",\"No\",3.8,3331,\"Time\",3
\"R0223\",\"Nakuru\",\"36-45\",1,\"Self-employed\",16368,\"Yes\",1190,\"No\",\"No\",1.8,1593,\"Skills\",4
\"R0224\",\"Nairobi\",\"56+\",4,\"Self-employed\",13696,\"Yes\",667,\"No\",\"No\",5.5,1237,\"Market access\",5
\"R0225\",\"Nairobi\",\"36-45\",1,\"Employed\",25680,\"Yes\",283,\"yes\",\"No\",5,5110,\"Capital\",5
\"R0226\",\"Mombasa\",\"46-55\",8,\"Self-employed\",9311,\"No\",39,\"Yes\",\"No\",3.5,774,\"Capital\",4
\"R0227\",\"Mombasa\",\"36-45\",1,\"Casual labour\",8968,\"yes\",959,\"Yes\",\"Yes\",5.8,1650,\"Capital\",3
\"R0228\",\"Nairobi\",\"26-35\",6,\"Employed\",NA,\"Yes\",939,\"Yes\",\"Yes\",5.2,1104,\"Capital\",3
\"R0229\",\"Kisumu\",\"26-35\",4,\"Self-employed\",8184,\"No\",85,\"Yes\",\"Yes\",5.1,NA,\"Capital\",1
\"R0230\",\"Embu\",\"26-35\",7,\"Casual labour\",9923,\"No\",96,\"No\",\"Yes\",5.7,NA,\"Skills\",3
\"R0231\",\"Nakuru\",\"36-45\",5,\"Employed\",20254,\"No\",150,\"No\",\"Yes\",6,2333,\"Capital\",2
\"R0232\",\"Nairobi\",\"26-35\",3,\"Self-employed\",10724,\"Yes\",680,\"Yes\",\"No\",4.4,1557,\"Time\",2
\"R0233\",\"Mombasa\",\"36-45\",5,\"Casual labour\",5872,\"Yes\",870,\"No\",\"No\",2.5,730,\"Market access\",2
\"R0234\",\"Kisumu\",\"26-35\",6,\"None\",934,\"No\",181,\"Yes\",\"No\",3.6,348,\"Time\",3
\"R0235\",\"Mombasa\",\"56+\",6,\"Casual labour\",5278,\"Yes\",943,\"Yes\",\"No\",5.9,NA,\"Skills\",5
\"R0236\",\"Nairobi\",\"46-55\",8,\"None\",NA,\"Yes\",985,\"Yes\",\"No\",5.2,1301,\"Time\",4
\"R0237\",\"Nakuru\",\"26-35\",4,\"None\",2481,\"Yes\",1060,\"yes\",\"Yes\",7.1,328,\"Time\",4
\"R0238\",\"Nairobi\",\"46-55\",3,\"Employed\",18187,\"No\",60,\"Yes\",\"Yes\",3.2,2790,\"Capital\",5
\"R0239\",\"Embu\",\"36-45\",3,\"Self-employed\",12380,\"Yes\",714,\"Yes\",\"No\",2.7,4824,\"Capital\",5
\"R0240\",\"Nairobi\",\"36-45\",6,\"Self-employed\",11072,\"No\",66,\"N/A\",\"No\",2.3,1147,\"Capital\",5
\"R0241\",\"Mombasa\",\"26-35\",4,\"Self-employed\",18488,\"Yes\",339,\"Yes\",\"No\",5.2,2192,\"Market access\",1
\"R0242\",\"Nairobi\",\"36-45\",6,\"Employed\",20365,\"Yes\",525,\"Yes\",\"No\",3,NA,\"Market access\",2
\"R0243\",\"Nairobi\",\"26-35\",5,\"Self-employed\",18092,\"Yes\",801,\"No\",\"No\",4.5,4674,\"Skills\",3
\"R0244\",\"Nairobi\",\"26-35\",6,\"Self-employed\",20754,\"No\",231,\"N/A\",\"Yes\",4.3,1454,\"Time\",5
\"R0245\",\"Embu\",\"36-45\",4,\"Casual labour\",5609,\"Yes\",1238,\"Yes\",\"Yes\",4.2,NA,\"Time\",5
\"R0246\",\"Nairobi\",\"36-45\",2,\"Self-employed\",13748,\"Yes\",1271,\"No\",\"No\",4.3,1134,\"Skills\",4
\"R0247\",\"Embu\",\"26-35\",4,\"Employed\",26484,\"No\",192,\"No\",\"Yes\",2.8,1904,\"Time\",3
\"R0248\",\"Kisumu\",\"26-35\",5,\"Employed\",19076,\"Yes\",975,\"Yes\",\"No\",2.9,2721,\"None\",4
\"R0249\",\"Kisumu\",\"36-45\",4,\"Self-employed\",7141,\"yes\",563,\"Yes\",\"No\",5.3,1590,\"Capital\",2
\"R0250\",\"Nairobi\",\"56+\",5,\"Employed\",19734,\"No\",81,\"No\",\"No\",2.2,2011,\"Market access\",2
\"R0251\",\"Nairobi\",\"36-45\",2,\"Casual labour\",3419,\"yes\",722,\"Yes\",\"Yes\",6.4,68,\"Market access\",3
\"R0252\",\"Nairobi\",\"26-35\",4,\"Employed\",NA,\"yes\",1082,\"Yes\",\"Yes\",2.9,654,\"Capital\",2
\"R0253\",\"Nairobi\",\"26-35\",4,\"Self-employed\",13182,\"Yes\",872,\"Yes\",\"Yes\",3.8,2587,\"Market access\",4
\"R0254\",\"Nakuru\",\"36-45\",5,\"Casual labour\",5747,\"Yes\",917,\"N/A\",\"Yes\",7.1,1375,\"Capital\",3
\"R0255\",\"Kisumu\",\"26-35\",2,\"None\",1277,\"No\",57,\"Yes\",\"No\",7.8,334,\"None\",1
\"R0256\",\"Nairobi\",\"46-55\",5,\"Casual labour\",4784,\"No\",206,\"N/A\",\"No\",6.2,647,\"Capital\",4
\"R0257\",\"Nakuru\",\"26-35\",3,\"None\",NA,\"Yes\",933,\"No\",\"No\",6,1435,\"Skills\",5
\"R0258\",\"Kisumu\",\"36-45\",5,\"Employed\",30533,\"Yes\",1114,\"No\",\"No\",7.1,8116,\"Skills\",3
\"R0259\",\"Mombasa\",\"36-45\",6,\"Casual labour\",5691,\"No\",105,\"Yes\",\"No\",5.2,757,\"Capital\",1
\"R0260\",\"Nairobi\",\"18-25\",6,\"Employed\",15558,\"Yes\",893,\"Yes\",\"Yes\",2.3,3781,\"Time\",2
\"R0261\",\"Embu\",\"18-25\",5,\"None\",828,\"No\",162,\"No\",\"Yes\",6.6,211,\"Time\",3
\"R0262\",\"Nairobi\",\"26-35\",6,\"Self-employed\",7950,\"No\",108,\"Yes\",\"No\",3.5,473,\"None\",3
\"R0263\",\"Nairobi\",\"36-45\",5,\"Self-employed\",6325,\"Yes\",446,\"Yes\",\"No\",5.8,1846,\"Market access\",5
\"R0264\",\"Mombasa\",\"56+\",4,\"Self-employed\",184,\"Yes\",1069,\"Yes\",\"Yes\",2.4,30,\"Capital\",5
\"R0265\",\"Nairobi\",\"36-45\",5,\"Employed\",24208,\"Yes\",1111,\"Yes\",\"No\",3.4,5088,\"Market access\",1
\"R0266\",\"Nairobi\",\"26-35\",5,\"Employed\",18056,\"No\",99,\"Yes\",\"Yes\",5.5,2944,\"Market access\",4
\"R0267\",\"Mombasa\",\"46-55\",5,\"Self-employed\",10872,\"No\",184,\"yes\",\"No\",4.3,1247,\"Capital\",4
\"R0268\",\"Mombasa\",\"26-35\",6,\"Casual labour\",7334,\"yes\",1135,\"Yes\",\"Yes\",4.2,2142,\"Time\",5
\"R0269\",\"Nairobi\",\"56+\",3,\"Casual labour\",3483,\"No\",56,\"No\",\"Yes\",3.6,958,\"Capital\",5
\"R0270\",\"Embu\",\"46-55\",6,\"Self-employed\",13794,\"Yes\",876,\"yes\",\"Yes\",2.7,1164,\"Market access\",4
\"R0271\",\"Mombasa\",\"26-35\",7,\"Casual labour\",9192,\"Yes\",1090,\"Yes\",\"Yes\",5.6,1551,\"None\",4
\"R0272\",\"Mombasa\",\"46-55\",3,\"None\",755,\"yes\",616,\"Yes\",\"No\",4.5,161,\"Capital\",4
\"R0273\",\"Nairobi\",\"36-45\",4,\"Casual labour\",5160,\"No\",243,\"No\",\"No\",6.2,140,\"Time\",5
\"R0274\",\"Nakuru\",\"26-35\",5,\"Self-employed\",14785,\"Yes\",NA,\"No\",\"No\",3,1981,\"Capital\",2
\"R0275\",\"Embu\",\"46-55\",5,\"Employed\",14991,\"No\",7,\"Yes\",\"No\",0.9,3122,\"Capital\",4
\"R0276\",\"Embu\",\"36-45\",8,\"Employed\",11314,\"Yes\",517,\"yes\",\"No\",4.9,1610,\"Capital\",3
\"R0277\",\"Nakuru\",\"36-45\",4,\"Self-employed\",14232,\"Yes\",807,\"Yes\",\"Yes\",3.2,92,\"Capital\",4
\"R0278\",\"Kisumu\",\"36-45\",6,\"Self-employed\",19478,\"Yes\",690,\"No\",\"Yes\",4.3,999,\"Time\",1
\"R0279\",\"Nairobi\",\"36-45\",6,\"Casual labour\",6817,\"yes\",NA,\"Yes\",\"No\",7.2,656,\"Capital\",4
\"R0280\",\"Kisumu\",\"36-45\",5,\"Self-employed\",18787,\"No\",129,\"No\",\"Yes\",4.9,NA,\"Time\",5
\"R0281\",\"Nakuru\",\"36-45\",6,\"Casual labour\",3299,\"No\",212,\"No\",\"No\",3.5,81,\"Skills\",5
\"R0282\",\"Embu\",\"26-35\",1,\"None\",2449,\"No\",93,\"Yes\",\"Yes\",4.4,514,\"Market access\",2
\"R0283\",\"Kisumu\",\"26-35\",5,\"Self-employed\",12365,\"Yes\",873,\"No\",\"Yes\",1.9,3154,\"Time\",2
\"R0284\",\"Nakuru\",\"56+\",5,\"Self-employed\",9983,\"No\",31,\"Yes\",\"No\",2.4,1246,\"None\",3
\"R0285\",\"Mombasa\",\"36-45\",5,\"Casual labour\",6474,\"No\",118,\"Yes\",\"Yes\",6.5,1590,\"Capital\",5
\"R0286\",\"Nakuru\",\"26-35\",8,\"Self-employed\",10592,\"No\",257,\"Yes\",\"No\",0.5,2625,\"Market access\",5
\"R0287\",\"Nairobi\",\"36-45\",5,\"Self-employed\",12186,\"No\",268,\"Yes\",\"No\",5.5,2055,\"Skills\",3
\"R0288\",\"Nakuru\",\"26-35\",3,\"Self-employed\",4180,\"Yes\",NA,\"Yes\",\"No\",3.7,590,\"Capital\",5
\"R0289\",\"Nakuru\",\"36-45\",5,\"None\",1805,\"yes\",735,\"Yes\",\"No\",9.5,279,\"Capital\",4
\"R0290\",\"Nairobi\",\"26-35\",4,\"None\",2462,\"No\",241,\"Yes\",\"No\",5,49,\"Skills\",3
\"R0291\",\"Kisumu\",\"46-55\",9,\"Employed\",22988,\"Yes\",625,\"yes\",\"Yes\",2.2,4938,\"Market access\",4
\"R0292\",\"Nairobi\",\"18-25\",6,\"Employed\",23230,\"Yes\",660,\"Yes\",\"No\",4.7,4572,\"Skills\",1
\"R0293\",\"Nakuru\",\"36-45\",4,\"None\",1792,\"YES\",968,\"No\",\"Yes\",7.8,283,\"Capital\",5
\"R0294\",\"Nakuru\",\"36-45\",1,\"Casual labour\",5099,\"yes\",158,\"No\",\"Yes\",7,242,\"Capital\",2
\"R0295\",\"Kisumu\",\"36-45\",3,\"Self-employed\",NA,\"Yes\",889,\"Yes\",\"No\",4.5,967,\"Time\",1
\"R0296\",\"Nairobi\",\"26-35\",4,\"Self-employed\",16104,\"Yes\",993,\"Yes\",\"No\",5.7,3466,\"Market access\",4
\"R0297\",\"Nakuru\",\"18-25\",2,\"Employed\",26465,\"Yes\",886,\"Yes\",\"No\",1.5,2648,\"Capital\",3
\"R0298\",\"Mombasa\",\"18-25\",4,\"None\",1431,\"No\",71,\"Yes\",\"Yes\",NA,359,\"Time\",2
\"R0299\",\"Nakuru\",\"26-35\",4,\"None\",241,\"Yes\",1087,\"No\",\"No\",7.8,52,\"Skills\",1
\"R0300\",\"Mombasa\",\"26-35\",6,\"Self-employed\",-999,\"No\",139,\"Yes\",\"No\",3.7,NA,\"Skills\",3
\"R0301\",\"Mombasa\",\"36-45\",6,\"Casual labour\",7785,\"Yes\",1330,\"Yes\",\"No\",5.1,584,\"Skills\",3
\"R0302\",\"Nakuru\",\"36-45\",4,\"Employed\",23961,\"Yes\",NA,\"Yes\",\"No\",4.7,2236,\"Market access\",4
\"R0303\",\"Kisumu\",\"26-35\",5,\"Self-employed\",9235,\"Yes\",926,\"Yes\",\"Yes\",1.8,1407,\"Skills\",3
\"R0304\",\"Embu\",\"36-45\",5,\"Self-employed\",8198,\"No\",92,\"No\",\"Yes\",4.3,744,\"Capital\",3
\"R0305\",\"Nairobi\",\"46-55\",1,\"Self-employed\",12692,\"Yes\",1055,\"No\",\"No\",4.1,1096,\"Capital\",5
\"R0306\",\"Nairobi\",\"56+\",5,\"Casual labour\",8056,\"No\",96,\"No\",\"No\",5.4,2246,\"None\",4
\"R0307\",\"Nakuru\",\"36-45\",6,\"Casual labour\",8022,\"No\",166,\"Yes\",\"Yes\",5,622,\"Capital\",2
\"R0308\",\"Nakuru\",\"26-35\",2,\"None\",843,\"No\",172,\"Yes\",\"Yes\",10.2,161,\"Market access\",3
\"R0309\",\"Nakuru\",\"36-45\",7,\"None\",1892,\"No\",125,\"Yes\",\"Yes\",4.1,86,\"Capital\",1
\"R0310\",\"Mombasa\",\"36-45\",4,\"None\",1261,\"No\",55,\"Yes\",\"No\",6.6,214,\"Capital\",4
\"R0311\",\"Nairobi\",\"26-35\",5,\"Employed\",15674,\"Yes\",851,\"Yes\",\"No\",2.6,3376,\"Market access\",5
\"R0312\",\"Kisumu\",\"56+\",4,\"Self-employed\",-999,\"No\",42,\"Yes\",\"No\",5.3,NA,\"Capital\",4
"

raw <- read.csv(text = csv_text, stringsAsFactors = FALSE,
                na.strings = c("", "N/A", "NA"))

numeric_cols <- c("monthly_income_kes", "weekly_savings_kes",
                  "care_hours_per_day", "health_expense_kes",
                  "household_size", "financial_stress_score")
for (col in numeric_cols) raw[[col]] <- suppressWarnings(as.numeric(raw[[col]]))

clean_yn <- function(x) {
  x <- toupper(trimws(x))
  x[x == "YES"] <- "Yes"
  x[x == "NO"]  <- "No"
  x
}

df <- raw
df$savings_group_member <- clean_yn(df$savings_group_member)
df$mobile_money_access  <- clean_yn(df$mobile_money_access)

df$monthly_income_kes[!is.na(df$monthly_income_kes) & df$monthly_income_kes < 0] <- NA
df$care_hours_per_day[!is.na(df$care_hours_per_day) & df$care_hours_per_day > 24] <- NA

df$savings_group_member <- factor(df$savings_group_member, levels = c("Yes", "No"))
df$mobile_money_access  <- factor(df$mobile_money_access,  levels = c("Yes", "No"))
df$smartphone_access    <- factor(df$smartphone_access,    levels = c("Yes", "No"))
df$stress_high <- ifelse(df$financial_stress_score %in% c(4, 5), "High", "Low/Moderate")

county_choices  <- c("All counties", sort(unique(df$county)))
source_choices  <- c("All sources", sort(unique(df$primary_income_source)))

# --- 2. Executive theme -------------------------------------------------------
# Palette: deep navy (#0A1F44) + muted gold (#B08D2B) on an off-white canvas.
# Single accent color used only for emphasis, per 60-30-10 rule.

navy       <- "#0A1F44"
navy_light <- "#13294B"
gold       <- "#B08D2B"
canvas     <- "#F5F5F2"
card_bg    <- "#FFFFFF"
ink        <- "#1C1C1C"
muted      <- "#6B7280"
slate      <- "#4B6584"
sage       <- "#7C9885"
terracotta <- "#B06A4E"

exec_theme <- tags$head(
  tags$link(rel = "stylesheet",
            href = "https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Playfair+Display:wght@600;700&display=swap"),
  tags$style(HTML(sprintf("
    body, .content-wrapper { background-color: %s !important; font-family: 'Inter', sans-serif; color: %s; }
    .main-header.navbar { background-color: %s !important; border-bottom: 2px solid %s; }
    .main-sidebar, .sidebar-dark-primary { background-color: %s !important; }
    .brand-link { background-color: %s !important; border-bottom: 1px solid rgba(255,255,255,0.08) !important; }
    .brand-text { font-family: 'Playfair Display', serif !important; font-weight: 700 !important; letter-spacing: 0.3px; color: #F5F5F2 !important; }
    .sidebar a, .sidebar label, .sidebar .form-control { color: #E5E5E0 !important; }
    .sidebar .selectize-input { background-color: %s !important; border: 1px solid rgba(255,255,255,0.15) !important; color: #fff !important; }
    .card { border: none !important; border-radius: 10px !important; box-shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.08) !important; background-color: %s !important; }
    .card-header { background-color: %s !important; border-bottom: 1px solid #EDEDE8 !important; border-radius: 10px 10px 0 0 !important; }
    .card-title { font-family: 'Playfair Display', serif !important; font-weight: 600 !important; color: %s !important; font-size: 16px !important; }
    .small-box, .info-box { border-radius: 10px !important; box-shadow: 0 1px 3px rgba(0,0,0,0.08) !important; }
    .exec-kpi { background-color: %s; border-radius: 10px; padding: 20px 22px; box-shadow: 0 1px 3px rgba(0,0,0,0.07); border-left: 4px solid %s; height: 100%%; }
    .exec-kpi .kpi-label { font-size: 12px; text-transform: uppercase; letter-spacing: 0.6px; color: %s; font-weight: 600; margin-bottom: 6px; }
    .exec-kpi .kpi-value { font-family: 'Playfair Display', serif; font-size: 30px; font-weight: 700; color: %s; line-height: 1.1; }
    .exec-kpi .kpi-sub { font-size: 12px; color: %s; margin-top: 4px; }
    .exec-header-title { font-family: 'Playfair Display', serif; font-size: 26px; font-weight: 700; color: %s; margin-bottom: 2px; }
    .exec-header-sub { font-size: 13px; color: %s; margin-bottom: 18px; }
    .content-header { display: none; }
  ", canvas, ink, navy, gold, navy, navy_light, navy_light, card_bg, card_bg, navy,
     card_bg, gold, muted, navy, muted, navy, muted)))
)

kpi_card <- function(label, value, sub, accent = "#B08D2B") {
  div(class = "exec-kpi", style = paste0("border-left-color:", accent, ";"),
      div(class = "kpi-label", label),
      div(class = "kpi-value", value),
      div(class = "kpi-sub", sub)
  )
}

exec_ggplot_theme <- theme_minimal(base_family = "sans", base_size = 12) +
  theme(
    plot.background = element_rect(fill = "white", color = NA),
    panel.background = element_rect(fill = "white", color = NA),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_line(color = "#ECECE6", linewidth = 0.4),
    panel.grid.major.y = element_blank(),
    axis.text = element_text(color = "#4B4B4B"),
    axis.title = element_text(color = "#4B4B4B", size = 11),
    plot.title = element_text(family = "sans", face = "bold", size = 13, color = "#0A1F44"),
    legend.position = "none"
  )

# --- 3. UI --------------------------------------------------------------------

ui <- dashboardPage(
  title = "FemDigiNomics | Executive Insights",
  fullscreen = TRUE,
  dark = NULL,
  header = dashboardHeader(
    title = dashboardBrand(title = "FemDigiNomics", color = "primary", image = NULL),
    skin = "dark",
    status = "primary",
    border = TRUE
  ),
  sidebar = dashboardSidebar(
    skin = "dark",
    status = "primary",
    collapsed = FALSE,
    div(style = "padding: 18px 15px 6px 15px; color: #E5E5E0; font-size: 11px; text-transform: uppercase; letter-spacing: 0.8px;",
        "Filters"),
    selectInput("county", NULL, choices = county_choices, selected = "All counties"),
    selectInput("income_source", NULL, choices = source_choices, selected = "All sources"),
    div(style = "padding: 20px 15px; color: #9AA0A6; font-size: 11px; border-top: 1px solid rgba(255,255,255,0.08); margin-top: 10px;",
        "HerEconomics Survey", br(), "n = 312 respondents", br(), "Synthetic data")
  ),
  body = dashboardBody(
    exec_theme,
    div(class = "exec-header-title", "Women\'s Economic Resilience Overview"),
    div(class = "exec-header-sub", "Savings, income, and financial stress indicators across surveyed counties"),

    fluidRow(
      column(4, uiOutput("kpi_n")),
      column(4, uiOutput("kpi_income")),
      column(4, uiOutput("kpi_savings"))
    ),
    br(),
    fluidRow(
      column(4, uiOutput("kpi_mobile")),
      column(4, uiOutput("kpi_stress")),
      column(4, uiOutput("kpi_care"))
    ),
    br(), br(),
    fluidRow(
      box(title = "Monthly Income by Source (KES)", status = "primary",
          solidHeader = FALSE, width = 6, headerBorder = TRUE,
          plotOutput("plot_income", height = "300px")),
      box(title = "Enterprise Barriers Reported", status = "primary",
          solidHeader = FALSE, width = 6, headerBorder = TRUE,
          plotOutput("plot_barriers", height = "300px"))
    ),
    fluidRow(
      box(title = "Unpaid Care Burden by Income Source", status = "primary",
          solidHeader = FALSE, width = 6, headerBorder = TRUE,
          plotOutput("plot_care", height = "300px")),
      box(title = "Financial Stress Distribution", status = "primary",
          solidHeader = FALSE, width = 6, headerBorder = TRUE,
          plotOutput("plot_stress", height = "300px"))
    )
  ),
  footer = dashboardFooter(
    left = "FemDigiNomics Executive Dashboard",
    right = "Prepared by Peter Thuo Muiruri"
  )
)

# --- 4. Server ------------------------------------------------------------

server <- function(input, output, session) {

  filtered <- reactive({
    d <- df
    if (input$county != "All counties") d <- d[d$county == input$county, ]
    if (input$income_source != "All sources") d <- d[d$primary_income_source == input$income_source, ]
    d
  })

  output$kpi_n <- renderUI({
    kpi_card("Respondents", nrow(filtered()), "Currently in view", accent = "#0A1F44")
  })

  output$kpi_income <- renderUI({
    d <- filtered()
    med <- median(d$monthly_income_kes, na.rm = TRUE)
    kpi_card("Median Monthly Income",
              paste0("KES ", comma(round(med))),
              "Across all income sources", accent = "#B08D2B")
  })

  output$kpi_savings <- renderUI({
    d <- filtered()
    pct <- round(mean(d$savings_group_member == "Yes", na.rm = TRUE) * 100, 1)
    kpi_card("Savings Group Membership", paste0(pct, "%"),
              "Of respondents in view", accent = "#7C9885")
  })

  output$kpi_mobile <- renderUI({
    d <- filtered()
    pct <- round(mean(d$mobile_money_access == "Yes", na.rm = TRUE) * 100, 1)
    kpi_card("Mobile Money Access", paste0(pct, "%"),
              "Have active mobile money", accent = "#4B6584")
  })

  output$kpi_stress <- renderUI({
    d <- filtered()
    pct <- round(mean(d$stress_high == "High", na.rm = TRUE) * 100, 1)
    kpi_card("High Financial Stress", paste0(pct, "%"),
              "Score of 4 or 5 out of 5", accent = "#B06A4E")
  })

  output$kpi_care <- renderUI({
    d <- filtered()
    mh <- round(mean(d$care_hours_per_day, na.rm = TRUE), 1)
    kpi_card("Mean Unpaid Care Hours", paste0(mh, " hrs/day"),
              "Time spent on unpaid care work", accent = "#0A1F44")
  })

  output$plot_income <- renderPlot({
    d <- filtered()
    ggplot(d[!is.na(d$monthly_income_kes), ],
           aes(x = primary_income_source, y = monthly_income_kes)) +
      geom_boxplot(fill = "#0A1F44", color = "#0A1F44", alpha = 0.85, width = 0.5, outlier.alpha = 0.4) +
      labs(x = NULL, y = "Monthly income (KES)") +
      scale_y_continuous(labels = comma) +
      exec_ggplot_theme +
      theme(axis.text.x = element_text(angle = 15, hjust = 1))
  })

  output$plot_barriers <- renderPlot({
    d <- filtered()
    bv <- d %>%
      filter(!is.na(enterprise_barrier)) %>%
      count(enterprise_barrier) %>%
      mutate(pct = round(n / sum(n) * 100, 1))
    ggplot(bv, aes(x = reorder(enterprise_barrier, pct), y = pct)) +
      geom_col(fill = "#B08D2B", width = 0.6) +
      geom_text(aes(label = paste0(pct, "%")), hjust = -0.15, size = 3.6, color = "#4B4B4B") +
      coord_flip(clip = "off") +
      labs(x = NULL, y = "% of respondents") +
      exec_ggplot_theme +
      expand_limits(y = max(bv$pct) * 1.25)
  })

  output$plot_care <- renderPlot({
    d <- filtered()
    cm <- d %>%
      filter(!is.na(care_hours_per_day)) %>%
      group_by(primary_income_source) %>%
      summarise(mean_hrs = round(mean(care_hours_per_day), 1))
    ggplot(cm, aes(x = reorder(primary_income_source, mean_hrs), y = mean_hrs)) +
      geom_col(fill = "#7C9885", width = 0.6) +
      geom_text(aes(label = paste0(mean_hrs, " hrs")), hjust = -0.15, size = 3.6, color = "#4B4B4B") +
      coord_flip(clip = "off") +
      labs(x = NULL, y = "Mean hours per day") +
      exec_ggplot_theme +
      expand_limits(y = max(cm$mean_hrs) * 1.25)
  })

  output$plot_stress <- renderPlot({
    d <- filtered()
    sd_ <- d %>% filter(!is.na(financial_stress_score)) %>% count(financial_stress_score)
    ggplot(sd_, aes(x = factor(financial_stress_score), y = n)) +
      geom_col(fill = "#B06A4E", width = 0.55) +
      labs(x = "Financial stress score (1 = low, 5 = high)", y = "Number of respondents") +
      exec_ggplot_theme
  })
}

shinyApp(ui, server)
