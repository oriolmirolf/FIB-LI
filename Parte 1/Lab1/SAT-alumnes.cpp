#include <iostream>
#include <stdlib.h>
#include <algorithm>
#include <vector>
using namespace std;

#define UNDEF -1
#define TRUE 1
#define FALSE 0

uint numVars;
uint numClauses;
vector<vector<int> > clauses;
vector<int> model;
vector<int> modelStack;
uint indexOfNextLitToPropagate;
uint decisionLevel;

int numConflicts;
bool switchToConflicts;

// Matrixes from 0 to n. 
// Position i holds vector of clauses where i-th variable has positive value.
vector<vector<int>> positiveOccurs;
// Position i holds vector of clauses where i-th variable has a negative value.
vector<vector<int>> negativeOccurs;

vector<int> totalOccurs;

vector<int> occursInConflicts;

void readClauses( ){
  // Skip comments
  char c = cin.get();
  while (c == 'c') {
    while (c != '\n') c = cin.get();
    c = cin.get();
  }  
  // Read "cnf numVars numClauses"
  string aux;
  cin >> aux >> numVars >> numClauses;
  clauses.resize(numClauses); 

  //mine
  positiveOccurs.resize(numVars + 1);
  negativeOccurs.resize(numVars + 1);
  totalOccurs.resize(numVars + 1);
  numConflicts = 0;
  switchToConflicts = false;

  // Read clauses
  for (uint i = 0; i < numClauses; ++i) {
    int lit;
    while (cin >> lit and lit != 0) {
      clauses[i].push_back(lit);
      
      //mine
      if (lit > 0) positiveOccurs[lit].push_back(i);
      if (lit < 0) negativeOccurs[-lit].push_back(i);

    }
  }

  for (uint i = 1; i <= numVars; ++i) {
    totalOccurs[i]= positiveOccurs[i].size() + negativeOccurs[i].size();
  }

  occursInConflicts = vector<int>(numVars + 1, 0);
}



int currentValueInModel(int lit){
  if (lit >= 0) return model[lit];
  else {
    if (model[-lit] == UNDEF) return UNDEF;
    else return 1 - model[-lit];
  }
}


void setLiteralToTrue(int lit){
  modelStack.push_back(lit);
  if (lit > 0) model[lit] = TRUE;
  else model[-lit] = FALSE;		
}

void addToVarsInClause(int c) {

  for (uint i = 0; i < clauses[c].size(); ++i) {
    int var = clauses[c][i];
    occursInConflicts[abs(var)]++;
  }

  ++numConflicts;
  if (numConflicts == 1000) {
    for (uint i = 1; i <= occursInConflicts.size(); ++i)
      occursInConflicts[i] /= 2;

    numConflicts = 0;
  }

  
}

bool propagateGivesConflict ( ) {
  while ( indexOfNextLitToPropagate < modelStack.size() ) {
    ++indexOfNextLitToPropagate;

    int val_to_check = modelStack[indexOfNextLitToPropagate-1];

    if (val_to_check > 0)
      for (uint i = 0; i < negativeOccurs[val_to_check].size(); ++i) {

        int c = negativeOccurs[val_to_check][i];

        bool someLitTrue = false;
        int numUndefs = 0;
        int lastLitUndef = 0;

        for (uint k = 0; not someLitTrue and k < clauses[c].size(); ++k){
          int val = currentValueInModel(clauses[c][k]);
          if (val == TRUE) someLitTrue = true;
          else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[c][k]; }
        }
        if (not someLitTrue and numUndefs == 0) {
          addToVarsInClause(c);
          return true; // conflict! all lits false
        }
        else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);	
      }

    else 
      for (uint i = 0; i < positiveOccurs[-val_to_check].size(); ++i) {

        int c = positiveOccurs[-val_to_check][i];

        bool someLitTrue = false;
        int numUndefs = 0;
        int lastLitUndef = 0;
        for (uint k = 0; not someLitTrue and k < clauses[c].size(); ++k){
          int val = currentValueInModel(clauses[c][k]);
          if (val == TRUE) someLitTrue = true;
          else if (val == UNDEF){ ++numUndefs; lastLitUndef = clauses[c][k]; }
        }
        if (not someLitTrue and numUndefs == 0) {
          addToVarsInClause(c);
          return true; // conflict! all lits false
        }
        else if (not someLitTrue and numUndefs == 1) setLiteralToTrue(lastLitUndef);	
      } 

  }
  return false;
}

void backtrack(){
  uint i = modelStack.size() -1;
  int lit = 0;
  while (modelStack[i] != 0){ // 0 is the DL mark
    lit = modelStack[i];
    model[abs(lit)] = UNDEF;
    modelStack.pop_back();
    --i;
  }
  // at this point, lit is the last decision
  modelStack.pop_back(); // remove the DL mark
  --decisionLevel;
  indexOfNextLitToPropagate = modelStack.size();
  setLiteralToTrue(-lit);  // reverse last decision
}


// Heuristic for finding the next decision literal:
int getNextDecisionLiteral(){
 int index_max = -1;
 int val_max = -1;

 for (uint i = 1; i <= occursInConflicts.size(); ++i) {
   int val = occursInConflicts[i];
   if (val*0.7 + 0.3*totalOccurs[i] > val_max and model[i] == UNDEF) {
     val_max = val*0.7 + 0.3*totalOccurs[i];
     index_max = i;
   }
 }
 
 if (index_max == -1) return 0;
 else return index_max;

}

void checkmodel(){
  for (uint i = 0; i < numClauses; ++i){
    bool someTrue = false;
    for (uint j = 0; not someTrue and j < clauses[i].size(); ++j)
      someTrue = (currentValueInModel(clauses[i][j]) == TRUE);
    if (not someTrue) {
      cout << "Error in model, clause is not satisfied:";
      for (uint j = 0; j < clauses[i].size(); ++j) cout << clauses[i][j] << " ";
      cout << endl;
      exit(1);
    }
  }  
}

int main(){ 
  readClauses(); // reads numVars, numClauses and clauses
  model.resize(numVars+1,UNDEF);
  indexOfNextLitToPropagate = 0;  
  decisionLevel = 0;
  
  // Take care of initial unit clauses, if any
  for (uint i = 0; i < numClauses; ++i)
    if (clauses[i].size() == 1) {
      int lit = clauses[i][0];
      int val = currentValueInModel(lit);
      if (val == FALSE) {cout << "UNSATISFIABLE" << endl; return 10;}
      else if (val == UNDEF) setLiteralToTrue(lit);
    }

  /*
  //Check if all true or false
  bool all_have_true = true;
  bool all_have_false = true;
  for (uint i = 0; i < numClauses and (all_have_true or all_have_false); ++i)
  {
    bool one_true = false;
    bool one_false = false;
    
    for (uint j = 0; j < clauses[i].size() and (not one_true and not one_false); ++j)
    {
      int lit = clauses[i][j];
      if (lit > 0) one_true = true;
      if (lit < 0) one_false = true;
    }

    if (all_have_false and not one_false) all_have_false = false;
    if (all_have_true and not one_true) all_have_true = false;
  }
  if (all_have_true or all_have_false) { cout << "SATISFIABLE HERE" << endl; return 20;}
  */

  // DPLL algorithm
  while (true) {
    while ( propagateGivesConflict() ) {
      if ( decisionLevel == 0) { cout << "UNSATISFIABLE" << endl; return 10; }
      backtrack();
    }
    int decisionLit = getNextDecisionLiteral();
    if (decisionLit == 0) { checkmodel(); cout << "SATISFIABLE" << endl; return 20; }
    // start new decision level:
    modelStack.push_back(0);  // push mark indicating new DL
    ++indexOfNextLitToPropagate;
    ++decisionLevel;
    setLiteralToTrue(decisionLit);    // now push decisionLit on top of the mark
  }
}  
