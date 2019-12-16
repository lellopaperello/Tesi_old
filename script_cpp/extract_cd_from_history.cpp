// Exstract the value of cd from all the 'forces_breakdown.dat' files in the
// folders named 'Re<ReynoldsNumber>'.

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

int main(int argc, char const *argv[]) {
   ifstream file;
   ofstream output ("polar.txt");
   string folder;
   string buffer;

   struct couple
   {
      double Re;
      double cd;

      // Constructor
      couple (double Re, double cd)
         : Re(Re), cd(cd) {}
   };

   vector<couple> polar; // Vector containing the pairs Re-cd


   // Extract the value of cd and store it
   for (int i = 1; i < argc; ++i) {
      folder = argv[i];    // convert "argv" to a string
      file.open(folder + "/forces_breakdown.dat");

      if (file.is_open()) {
        // read all the file and search for "Total CD"
        while (getline(file, buffer)) {
           if (buffer.find("Total CD:") != string::npos) {
              polar.emplace_back (
                 stod(folder.substr(2)),
                 stod(buffer.substr(16, 8)) );
           }
        }
     }else if (output.is_open()) {
        output << "Unable to open file" << '\n';
     }else{
        cout << "Unable to open input and/or output file " << '\n';
     }

     file.close();
   }

   sort(polar.begin(), polar.end(),
        [](const auto& i, const auto& j) { return i.Re < j.Re; } );

   // Writing data to file "polar"
   // Format: Re \t cd
   for (int i = 0; i < polar.size(); ++i){

   output << polar[i].Re << '\t' << polar[i].cd << '\n';
   }
































   // std::string mystring;
   // std::vector<double> Re;
   //
   // mystring = argv[1];
   // Re.push_back (std::stod (mystring.substr(2)));
   // std::cout << Re[0] << std::endl;
   //
   // std::cout << "Have " << argc << " arguments:" << std::endl;
   //  for (int i = 1; i < argc; ++i) {
   //      mystring = argv[i];
   //      Re.push_back (std::stod (mystring.substr(2)));
   //  }
   //
   //  std::sort(Re.begin(), Re.end());
   //
   //  for (int i = 0; i < argc-1; ++i) {
   //     std::cout << Re[i] << std::endl;
   //  }
   return 0;
}
