/* Copyright (c) 2020 Digidactylus AB. 
   This file is distributed under the MIT license 
*/


#include "FileParser.h"
#include <stdlib.h>




StringParser::StringParser()
{
  m_bNoMult = false;
}


StringParser::~StringParser()
{
  m_file.Close();
}

void StringParser::KeepEmpty(bool b)
{
  m_bNoMult = b;
}

void StringParser::SetLineDelim(const string & line)
{
  int i;
  CMTokenizer t;

  for (i=0; i<m_delim.isize(); i++)
    t.AddDelimiter(m_delim[i].c_str());

  CMPtrStringList tokens;

  t.Tokenize(tokens, line.c_str(), m_bNoMult);

  m_items.clear();

  m_items.resize(tokens.length());
  for (i=0; i<tokens.length(); i++)
    m_items[i] = (const char*)*tokens(i);
}

void StringParser::SetLine(const string & line, const string & delim)
{
  int i;
  CMTokenizer t;
  t.AddDelimiter(delim.c_str());

  CMPtrStringList tokens;

  t.Tokenize(tokens, line.c_str(), m_bNoMult);

  m_items.clear();

  m_items.resize(tokens.length());
  for (i=0; i<tokens.length(); i++)
    m_items[i] = (const char*)*tokens(i);
}

void StringParser::SetLine(const string & line)
{
  CMPtrStringList tokens;
  Tokenize(tokens, line.c_str());

  m_items.clear();

  m_items.resize(tokens.length());
  //cout << "len " << tokens.length() << endl;
  for (int i=0; i<tokens.length(); i++)
    m_items[i] = (const char*)*tokens(i);
}

int StringParser::GetItemCount()
{
  return (int) m_items.size();
}

bool StringParser::IsString(int index)
{
  //always true....
  return true;
}


bool StringParser::IsInt(int index)
{
  const char * p = m_items[index].c_str();
  int n = strlen(p);

  for (int i=0; i<n; i++) {
    if (p[i] < '0' || p[i] > '9')
      return false;

  }
  return true;
}


bool StringParser::IsFloat(int index)
{
  const char * p = m_items[index].c_str();
  int n = strlen(p);

  for (int i=0; i<n; i++) {
    if (p[i] < '0' || p[i] > '9') {
      if (p[i] != '.')
	return false;
    }

  }
  return true;
}


const string & StringParser::AsString(int i)
{
  return m_items[i];
}

char StringParser::AsChar(int i)
{
  return m_items[i][0];
}

int StringParser::AsInt(int i)
{
  return atol(m_items[i].c_str());
}


double StringParser::AsFloat(int i)
{
  return atof(m_items[i].c_str());

}



//=======================================================
FlatFileParser::FlatFileParser() : StringParser()
{
  m_fromRedir = false;
}

FlatFileParser::FlatFileParser(const string & fileName)
{
  m_fromRedir = false;
  Open(fileName.c_str());
}

FlatFileParser::~FlatFileParser()
{
  m_file.Close();
}
void FlatFileParser::Open(const string & fileName)
{
  if (fileName == "") {
    m_fromRedir = true;
  } else {
    m_file.Open(fileName.c_str());
  }
}

bool FlatFileParser::Exists(const string &fileName)
{
  ifstream istrm(fileName.c_str());
  bool isFile = istrm.is_open();
  istrm.close();

  return isFile;

}

bool FlatFileParser::ParseLine(const string & delim)
{
  CMString line;
  if (!m_fromRedir) {
    if (m_file.IsEnd())
      return false;
    m_file.ReadLine(line);
  } else {
    char * buffer = new char[1000000];
    if (fgets(buffer, sizeof(buffer) , stdin) == NULL) {
      return false;
    }
    buffer[strlen(buffer)-1] = 0;
    line = buffer;
    delete [] buffer;
  }

  if (delim == "") {
    if (m_delim.isize() == 0)
      SetLine((const char*)line);
    else
      SetLineDelim((const char*)line);
  } else {
    SetLine((const char*)line, delim);
  }
  m_line = line;
  
  return true;
}

bool FlatFileParser::GetLine(string & line2)
{
  CMString line;
  m_file.ReadLine(line);
  if (m_file.IsEnd())
    return false;

  line2 = (const char*)line;

  return true;
}

bool FlatFileParser::IsEndOfFile()
{
  return m_file.IsEnd();
}

void FlatFileParser::LoadVector(string &filename,
				vector<string> &element)
{
  element.clear();
  string line("");
  this->Open(filename);
  while (this->ParseLine())
  {
    element.push_back(m_line);
  }
}

void FlatFileParser::LoadSet(string &filename,
			     set<string> &element)
{
  element.clear();
  this->Open(filename);
  while (this->ParseLine())
  {
    element.insert(m_line);
  }
}






