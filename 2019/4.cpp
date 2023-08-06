#include "bits/stdc++.h"
using namespace std;

#define forn(i, n) for (int i = 0; i < int(n); i++)
#define ll long long
const char *alphabet = "abcdefghijklmnopqrstuvwxyz";

int calcpass(string input,char mode){
  int delimiter = find(input.begin(),input.end(),'-') - input.begin();
  ll fromx = stoll(input.substr(0,delimiter));
  ll to = stoll(input.substr(delimiter+1,input.size()-delimiter+1));
  int result = 0;
  for(ll i = fromx; i < to; i++){
    // cout << i << endl;
    ll increasing = 1;
    string splitnumber = to_string(i);
    map<int,int> adjacentdigitslist;
    map<int,int> adjacentdigitslistelf;
    ll adjacentdigits = 0;
    int prevchar = -1;
    forn(k,splitnumber.size()){
      int xo = int(splitnumber[k]);
      if(adjacentdigitslist[xo] == 0)
          adjacentdigitslist[xo] = 0;
      adjacentdigitslist[xo]++;

      if(adjacentdigitslist[xo] > 1)
          adjacentdigits = 1;

      if(prevchar == int(xo)){
        if(adjacentdigitslistelf[xo] == 0){
          adjacentdigitslistelf[xo] = 1;
        }
        adjacentdigitslistelf[xo]++;
      }

      if(prevchar <= int(xo)){
        prevchar = int(xo);
        continue;
      }

      increasing = 0;

      break;
    }

    if(increasing == 0)
      continue;

    if(mode == 'e'){
      adjacentdigits = 0;
      for(auto j : adjacentdigitslistelf){
        if(j.second != 2)
          continue;
        adjacentdigits = 1;
        break;
      }
    }
    if(adjacentdigits == 0)
      continue;
    result++;
  }
  return result;
  // return 0;
}
void run_case()
{
}

int main()
{

  int ans1 = calcpass("146810-612564",'c');
  cout << "part 1: " << ans1 << endl;


  int ans2 = calcpass("146810-612564",'e');

  cout << "part 2: " << ans2 << endl;
  return 0;
}
