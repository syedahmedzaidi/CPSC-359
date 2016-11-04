Mic1MMV Simulator v2.0 README File
--------------------------------------
Richard M. Salter (rms@cs.oberlin.edu)
--------------------------------------
December, 2005
--------------------------------------
c. 2005 Prentice-Hall
--------------------------------------
Release 1.01
--------------------------------------
Release History:
	1.00 (March, 2005)
	1.01  (January, 2006)
--------------------------------------

This README file will help you get acquainted with the Mic1MMV
simulator. It contains the following sections:

	   I.   Contents of the distribution
	   II.  Installation
	   III. Examples
	   IV.  Using the Help System

At the end of this document are descriptions of updates to the
original release.

I. Contents of the distribution

Mic1MMV is delivered in the following 5 subfolders:
   bin
	Mic1MMV_hr.jar
	Mic1MMV_lr.jar
	    Executable Java jar files containing the simulator program
	    (hi-res and low-res versions, respectively).
	runMic1.bat
	    A batch file for launching the simulator.
   lib
	ijvm.conf
	    A configuration file for the ijvmasm
	    assembler. Contains a description of the assembly
	    language which includes the opcode, mnemonic, and
	    operand types for each instruction.
	mic1.properties
	    A sample properties file.
	GNU.TXT
	    A copy of the GNU General Public License.
   examples
	MAL
	    A folder containing mic1ijvm.mal, the source micro
	    assembly language file (MAL file) for the standard IJVM
	    interpreter.
	JAS-IJVM
	    A folder containing several sample Integer Java Virtual
	    Machine (IJVM) programs, in source code form (JAS files)
	    and object code form (IJVM files).
   doc
	UserGuide.jar
	    A standalone version of the user guide.
	    To run, double-click or launch from the command line:
		    java -jar UserGuide.jar
	UserGuide_hs.jar
	    The JavaHelp helpset for this user guide. Needs to stay in
	    this folder.
   src
	Mic1MMV_xxx.zip
	    A zip file containing source code for Mic-1 MMV. 
	    Note: The Mic-1 MMV jar files in this release bundle the
	    Javahelp classes contained in the archive jh.jar,
	    distributed by Sun Microsystems and licensed as part of
	    the Java 2 Standard Edition. See
	    http://java.sun.com/products/javahelp/.  This source zip
	    only contains files for which the copyright is owned by
	    Prentice-Hall. Recompilation will require reference to the
	    files of jh.jar in the classpath.

II. Installation

The Mic-1 MMV software requires the Java Runtime Environment (JRE) 1.4
or later. Visit http://java.sun.com/j2se/ to find a JDK or JRE for
your platform.

If you are installing from the CD-ROM, you have already copied the
folder Mic1MMV to your drive. Skip to Step 2.

If your are installing from the Website, you need to unpack before
proceeding.

1. Windows NT/XP unpacking
      Run the self-extracting zip file Mic1MMV.exe. The folder Mic1MMV
      will be created and all program files, source code, and
      documentation will be extracted into that folder.

   Unix/Linux unpacking
      To decompress Mic1MMV.tar.gz under Unix-like operating systems,
      you'll need the GNU gunzip program or other compatible
      decompression software, and the tar program. GNU software is
      available from a number of FTP sites which are listed at
      http://www.gnu.org/order/ftp.html. If you're using gunzip, at a
      shell prompt, type:

	  $ gunzip mic1.tar.gz
	  $ tar xvf Mic1MMV.tar

      You may instead be able to do this in one step if you're using GNU tar: 

	  $ tar xzf Mic1MMV.tar.gz 

      This will create the Mic1MMV directory, as in Windows unpacking

   Macintosh unpacking
      Double-click (or open with Stuffit Expander) the file
      Mic1MMV.tar.gz. This will create the folder Mic1MMV, as in 
      Windows unpacking.

2. There are two jar files in the Mic1MMV folder: Mic1MMV_lr.jar is
   designed to work on low resolution screens, while Mic1MMV_hr.jar is
   intended for high resolution screens. If you are using a resolution
   of 1280 x 960 or higher, you should use Mic1MMV_hr.jar; otherwise
   use Mic1MMV_lr.jar. 

   When Mic1MMV is launched, it automatically loads a microcode
   program. At first this program is mic1ijvm.mic1, the IJVM microcode
   interpreter described in Chapter 4 of Tanenbaum, "Structured
   Computer Organization, 5th Edition". You can load a different
   microprogram once Mic1MMV is running, or even specify a different
   microprogram to load on startup. See the User Guide for details.

2. Windows users:
      make sure your PATH variable points to the Java
      bin directory (Java installation should take care of this).

   Unix/Linux users:
      set the PATH environment variables. In order to run any of the
      Mic-1 MMV software, the PATH variable must contain the path of
      the JDK executables. To see if the PATH is set correctly, type
      which java. If a directory path is returned, the PATH is
      properly set. If nothing is returned, you need to find the jdk
      and then set the PATH.

   Mac OSX users:
      check that the Java JRE is properly installed on your
      machine. You should be able to launch the jar files by double
      clicking on their icons.

3. Try both Mic1MMV_hr.jar and Mic1MMV_lr.jar, and rename the
   appropriate file Mic1MMV.jar. Launch, either by double-clicking the
   icon or with the terminal console command:

      java -jar Mic1MMV.jar

   Alternatively, edit the batch file runMic1.bat and use it to launch
   the simulator. Instructions for editing runMic1.bat are contained
   in that file.


IV. Examples

Example 1: Loading and Running an IJVM Program

This example shows you how to load an IJVM program and run it without
interruption. 

1. Launch the simulator, as described in Step 3 under Installation.
2. On the Menu Bar select "File | Load IJVM program ...."
3. In the File chooser, navigate to 
   "examples/JAS-IJVM Examples". If you have launched from the bin
   directory, this folder is found by moving up one level, then down
   through the "examples" folder.
4. Select ijvmtest.ijvm. The IJVM program should appear in the Method Area.
5. Select Prog Speed on the Command Console (i.e. the radio button
   labeled "Prog")
6. Click the Run button (the one with the blue right arrow) on the
   Command Console to begin interpretation of the IJVM program by the
   default microprogram. After a brief period, while the simulator is
   running, you should see the following in the "Output Console" text
   area:

       OK

Example 2: Assembling a JAS program.

This example shows you how to edit, and assemble a JAS source program,
and load the resulting IJVM object program.

1. Find the file examples/JAS-IJVM Examples/ijvmtest.jas 
2. Open this file in your favorite editor (emacs, notepad, etc.)
3. Go to line 451.
4. Replace the lines:

      OK:	BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT
   with

      OK:	BIPUSH 65
		OUT
		BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT

   and save the changes.
5. On the simulator select from the Menu Bar
   "File | Assemble/Load IJVM program ...."
   Navigate as before to examples/JAS-IJVM, and select
   ijvmtest.jas.
6. The "Assembling ijvmtest.jas ..." window should appear, with
   "assembly complete" appearing soon in the text area. Click the Load
   button.
7. Select Prog Speed and click the Run button, as before. You should
   now see in the Output Console:

      AOK

Example 3: Re-assembling a JAS program.

Once a JAS file has been assembled and loaded, it can be re-assembled
and loaded using "Assemble/Load | Current JAS Assemble/Load" without
requiring further file selection. This example also shows what happens
when there is an error in a JAS program.

1. After completing Example 1, re-edit ijvmtest.jas, remove the colon
   after OK, and save the changes:

      OK	BIPUSH 65
		OUT
		BIPUSH 79
		OUT
		BIPUSH 75
		OUT
		HALT

2. On the simulator select from the Menu Bar
   "Assemble/Load | Current JAS Assemble/Load"
   The "Assembling ijvmtest.jas" window should appear with the
   following error message:

	 IJVM Assembler...
	 1433: Invalid instruction: ok
	 1424: Invalid goto label: ok

3. Close the window and re-edit the file:  put back the colon and
   remove the lines

	 BIPUSH 65
	 OUT
	 
   so that the program looks like it did originally. 
4. Try Step 2 again, this time without errors. Load the program, click
   the Reset button, and run it again.  The result in the Output
   Console should be "OK", just like the first time.

Example 4: Trying different speeds.

In this example you will see how the simulator operates at different
"speeds". Here "speed" means the amount of computation that takes
place when the Run button is clicked once. You will also see how to
use the Delay Mode to demonstrate the action of the simulator.

1. Launch the simulator and from
   "File | Assemble/Load IJVM program ...." select
   examples/JAS-IJVM/add.jas. Load the program when it finishes
   assembling. 
2  Try it first at Prog Speed. This program adds 2 hexidecimal
   numbers. Run the program, and type the following into the Input
   Console:

	1234   	
	5678

   Note the echoing in the Output Console. When you are done, the
   Output Console should contain

	1234
       +5678
       ========
       000068AC

   You can enter another pair of numbers to sum in the Input
   Console. (Be sure to use capitals A ... F for the high-end hex
   digits.) Click "Stop" (the stop sign) when you are done.
3. Now click Reset, and change the speed to IJVM Speed.
4. Click the Run button several times, and note the highlighting of
   IJVM instructions in the Method Area. Each click executes a single
   IJVM instruction. You can also click the Reverse button (the
   left-pointing red arrow) to backup a step.
5. Now select Delay On (another radio button) and click Reset and the
   Run button as in the previous step. Note that the sequence of
   microcode instructions used to interpret the current IJVM
   instruction is shown, and the data path is illustrated in the
   Architecture View (the leftmost window showing the registers and
   busses).
6. Select Delay Off and Clock Speed, then Reset and Run several
   steps. Each step shows the execution of one microinstruction. 
   The Reverse button backs up one microinstruction. On
   the Menu Bar select "Microstore | View Microstore". The Microstore
   Window will appear, and you can follow the execution of the
   microprogram while clicking Run. Try it with Delay On to see the
   subcycles illustrated as before. 
7. Finally, select Delay Off and SubClock Speed, then Reset and Run
   several steps. Each step is now a quarter cycle. Reverse works as
   you'd expect, but Delay On has no effect at this speed.

V. Using the Help System

User Guide
     The complete documentation for the Mic1MMV microarchitecture
     simulator and related software can be launched by selecting "Help
     | Mic1MMV Help" from the Menu Bar. Alternatively, it can be run
     apart from the simulator by running docs/UserGuide.jar; i.e.

	   java -jar UserGuide.jar

Context-sensitive Help
     The Menu entry "Help | Mic-1 MMV Help On" launches
     context-sensitive help. Users can use this to obtain help
     about any GUI object. When selected, the cursor changes to the
     help cursor. When the user next clicks on a GUI object, help
     information for that object is displayed.

Launch the Help browser and in the Table of Contents pane on the left
click Introduction. Among the sections you can visit are:

Getting Started
	Essentially the same material as in this README.

Program Operation
	The Overview has a Visual Quick Tour. The diagrams in this
	section are "hot": click on a feature and jump to a
	description of that feature.

	Running the Simulator describes running at different speeds
	and contains an example that demonstrates setting breakpoints.

	Setting Preferences describes the Preference panel, and the
	user options you can set.

	Controls and Viewers are detailed descriptions of each Mic1MMV
	feature.

	Using Mic1MMV describes how you can develop microcode programs
	using the simulator, analogous to the JAS -> IJVM examples
	presented here.  It also discusses modifying the JAS assembler.

Programming Manuals
	Specifications of the MAL and JAS languages.

------------------------------
Release 1.01 (December, 2005)

1. Addition to Preferences: a line has been added to permit user
   specification of the control store location of "Main1" in the IJVM
   interpreter. Execution of the instruction at Main1 is used by
   Mic1MMV to recognize that a new IJVM instruction is being
   interpreted. By default, this value is 0002, but the compiler may
   relocate Main1 if the interpreter changes.

   As an alternative to having to change the Main1 location in
   preferences each time the interpreter is revised, the user is
   advised to "anchor" the label Main1. Such an anchor has been added
   to the prototype interpreter mic1ijvm.mal.

2. The lookup path for default microcode, IJVM and configuration file
   ijvm.conf has been more precisely specified.

   Lookups take place in the following order:
	   the current directory;
	   the launch directory;
	   if these fail, an internal version is used.

   When the program is launched, the current directory is set to the
   launch directory (i.e. the directory containing the Mic1MMV jar
   file). The current directory may be subsequently changed to load
   IJVM or MAL files, but the launch directory remains fixed.

   Each time a MAC or IJVM file is loaded, the directory containing
   that file is checked for a copy of the IJVM configuration file (as
   defined in Preferences). If one is found, it is loaded and used to
   process the newly loaded MAC or IJVM file. It is recommended,
   therefore, that you collect all MAC files using a particular
   configuration into a single directory containing the appropriate
   configuration file.

   Full paths for all current files are now provided in the "About
   Box", which can be opened from the Help menu. (Note: the path
   "resource\<file name>" is used to indicate the internal version).
