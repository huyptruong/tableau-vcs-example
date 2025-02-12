# Introduction
This tutorial discusses how to do version control with Tableau workbooks and prep flows. This concept is different from revision history on Tableau Server or Tableau Cloud.

## Step 1: Set up and Configure your Workflow

Please do the following: 
* Set up a GitHub account
* Install the latest version of Visual Studio Code (referred as **vscode** for short)

Do the following only if you want to use command line.

* For Windows users only: Install the latest version of Git Bash. Then set Git Bash as the default terminal
    * Open vscode
    * Press Ctrl + ` (backtick is the key to the left of keyboard 1) to open a terminal.
    * Click on the down arrow next to + then choose Select Default Profile. You will see a dropdown at the top of the screen. Select Git Bash.
    * Close vscode and reopen it. Git Bash is now your default terminal. You can check this by clicking on the down arrow next to +. You should see Git Bash (Default)
* For Mac users only:
    * Open vscode
    * Press Ctrl (not Command) + ` (backtick is the key to the left of keyboard 1) to open a terminal.
    * Install Homebrew, which is a package manager for Mac.
    * Install git via the command, `brew install git`.
    * Check if git has been installed via the command, `git --version`.
    * Install Oh My Zsh via the command.

## Step 2: Clone This Project

* Navigate to https://github.com/huyptruong/tableau-vcs-example 
* A few lines down, click on a green button called **Code** > Local HTTPS > click on two overlapped squares to copy the link.
* Go back to the Git Bash terminal and type in the following
```
mkdir git_repos
cd git_repos
git clone <https://github.com/huyptruong/tableau-vcs-example >
```
* You may need to provide your credentials
    * Username
    * Password

## Step 3: Open the Project

* In the git bash terminal, type ```code tableau-vcs-example --reuse-window``` to open this project in vscode.
    * If it doesn't work, Open the Command Palette (Cmd + Shift + P)
    * Type and select Shell Command: Install 'code' command in PATH.
    * This should set up the code command in your system’s PATH.
* Press Ctrl + W to close the Welcome window.
* In the terminal, type ```cd tableau-vcs-example```
* At this point, you're in the directory of this project
    * To the left is the EXPLORER dock that shows your project along with files in that it currently has.
    * In the middle is the coding area. Files you open will most likely show up here.

## Step 4: Basics of Doing Version Control with Tableau Workbooks

*Note that this type of version control is not the same as Revision History feature you may have on your Tableau server or Tableau Cloud. Revision history is similar to saving the workbook with different timestamps.*

The basic idea of doing version control with Tableau is to convert the workbook or the prep flow to an XML-based text file. Then changes to the Tableau file can be viewed by inspecting the XML file. Given a Tableau workbook called executive_dashboard.twb, below are the steps to extract the XML-based file from it if we wish to do it manually:
1. Open executive_dashboard.twbx.
2. Save it as a twbx file, executive_dashboard.twbx.
3. Rename it to executive_dashboard.zip
4. Unzip executive_dashboard.zip to a folder called executive_dashboard. Inside this folder, you'll see the workbook, executive_dashboard.twb, along with other folders or files. For example, if your workbook connects to a local data source such as this one (Sample - Superstore.xlsx), you'll see a folder called Data that has this data source in it. However, if your workbook connects to a data source on a server, then there's nothing in this folder.
5. Rename executive_dashboard.twb to executive_dashboard.txt. This is the XML-based file we'll use to view changes.

The script **git_tab.sh** in this tutorial automates this process for both Tableau workbook and Tableau Prep flows. It clean up redundant files to free up some space. Once you run this script, vscode's EXPLORER window will show a .txt file next to the .twb file. Some basic setup steps are needed to use it effectively. In the terminal, do the following:
1. Type ```chmod +x git_tab.sh```
2. Type ```echo "export PATH=\$PATH:$(pwd)"```. Then copy the output. It should look something like this, ```export PATH=$PATH:/c/git_repos/tableau-vcs-example```
3. Type ```nano ~/.bashrc```. This will open up a text editor window.
4. Copy/Paste the output in step 2. Press Ctrl + X, then Y (for Yes), and enter.
5. Back to the terminal and type ```source ~/.bashrc```

After this step, you'll be able to call **git_tab.sh** anywhere. You're now ready to do version control with Tableau.

# Tableau Version Control Example

As an exercise, we'll build the following dashboard along with doing version control on it. This dashboard comes from the following site, https://workout-wednesday.com/2020w53/

![Workout Wednesday 2020 Week 53](supplementary_images/dashboard_final_sketch.png)

Although the dashboard is relatively simple, the idea behind this exercise is not to build it one stroke. Rather we'll break it down into small portions that can be built easily with traceable commits. At a glance, the dashboard is composed of the KPI and some line charts that serve as the core visualization. The following exercises outline the steps to build them:
1. Exercise 1: Make the First Commit. Build the KPI sheet. No formatting is needed.
2. Exercise 2: Enahnce the KPI Viz. Improve the KPI sheet with all the formatting as shown in the final dashboard.
3. Exercise 3: Finish the Core Viz. Build the line charts since they look all similar.
4. Exercise 4: Complete the Prototype Dashboard. Build the dashboard shown above.
5. Bonus Exercise: Resolve a Merge Conflict. Simulate a merge conflict on Tableau workbooks and discuss a strategy to resolve it.

## Excercise 1: Make the First Commit

In this exercise, we'll build the KPI sheet as our first visualization and commit it. No formatting is required.

As a good development practice, we will create a branch to work on this visualization. In the terminal, type `git checkout -b kpi`. We are now on a separate branch called *kpi*. Work on this branch won't affect the main branch.

Now, open the Tableau workbook with the following command, `start executive_dashboard.twb`, and build the visualization as shown below.

![KPI](supplementary_images/kpi_no_format.png)

We're ready to make our first commit!
* Save the workbook
* Export it as a twbx. <strong style="color:red;">This step is important for version control.</strong>
* Close the workbook
* In the terminal, type ```git_tab.sh executive_dashboard.twbx```.
* To view it, type ```code executive_dashboard.txt```.
    * The txt file contains the workbook's structure as xml. Ctrl + F to search for the word *KPI* and you can see how the KPI sheet was built.
    * For instance, the aggregation used on Discount was average, while on Sales was sum (look for the word *derivation*).
* To commit, type the following to the terminal:
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "KPI sheet initial build"
git switch main
git merge kpi # an input window might appear, but you can just close it
```

## Exercise 2: Enhance the KPI Viz

In this exercise, we will enhance the KPI viz with all the formatting. Do the following in the terminal
```
git switch kpi # switch back to the kpi branch
start executive_dashboard.twb
```
Then format the KPI viz as shown below

![KPI](supplementary_images/kpi_with_format.png)

We're ready to make our second commit!
* Save the workbook
* Export it as a twbx
* Close the workbook
* In the terminal, type ```git_tab.sh executive_dashboard.twbx```.
* To view it, type ```code executive_dashboard.txt```.
    * In the popup text file, you'll see some color coding that depicts the changes (i.e., wha was added, what was removed, etc.). If this is hard to see, vscode offers a color highlighting feature to see the diffs even easier -- in the top right corner, look for a symbol called *Open Changes*. 
    * Once you get used to git, another way to see the changes is via the command ```git diff <executive_dashboard.txt>```.

<mark>Notice</mark> how the sub-text (SALES, PROFIT, etc.) was capitalized by changing their aliases. Because there are many ways to achieve the same result in Tableau, it’s not immediately obvious how this was done just by looking at the sheet. This highlights another benefit of using version control in Tableau: an analyst can quickly understand how something was accomplished. Such knowledge is essential for successfully executing mid- to large-scale Tableau projects, where tracking and maintaining existing work is just as important as adding new features. In these projects, even small change requests can feel overwhelming because of the sheer number of calculated fields that may have been created. The last thing anyone wants is to add more calculations just to achieve a desired format.

Relying on a sheet’s caption feature is clearly inadequate, simply because not everyone remembers to document their work. Personally, I have seen very few Tableau workbooks with good captions. Our minds are often too busy with other tasks!

Finally, don't forget to commit and merge to the main branch
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "enhance KPI sheet with formats"
git switch main
git merge kpi # an input window might appear, but you can just close it
```

## Exercise 3: Finish the Core Visualizations

In this exercise, we finish the line charts and commit them to git. Start by creating a branch called *core_viz* and work on this branch, `git checkout core_viz`.

### Exercise 3.1: Consumer Chart and Number

![Consumer Chart](supplementary_images/consumer_chart.png)
![Consumer Chart](supplementary_images/consumer_number.png)

Follow the process in Exercise 2 to extract an XML-based file from the workbook and view the diffs with the *Open Changes* feature (top right corner). You can see that the information on filtering is encoded in the filter class. For example, the filter (Segment: Consumer) is shown as `member='&quot;Consumer&quot`.
* Save the workbook
* Export it as a twbx
* Close the workbook
* In the terminal, type ```git_tab.sh executive_dashboard.twbx```.

Don't forget to commit the changes!
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "added the consumer chart and sales number"
```

### Exercise 3.2: Corporate Chart and Number
![Consumer Chart](supplementary_images/corporate_chart.png)
![Consumer Chart](supplementary_images/corporate_number.png)

* Save the workbook
* Export it as a twbx
* Close the workbook
* In the terminal, type ```git_tab.sh executive_dashboard.twbx```.
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "added the corporate chart and sales number"
```

### Exercise 3.3: Home Office Chart and Number
![Consumer Chart](supplementary_images/home_office_chart.png)
![Consumer Chart](supplementary_images/home_office_number.png)

* Save the workbook
* Export it as a twbx
* Close the workbook
* In the terminal, type ```git_tab.sh executive_dashboard.twbx```.
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "added the home office chart and sales number"
```

Finally, merge *core_viz* to main branch
```
git switch main
git merge core_viz # an input window might appear, but you can just close it
```

## Exercise 4: Complete the Prototype Dashboard

In this exercise, we finish prototyping the dashboard and commit it to git. Start by creating a branch called *dashboard-prototype* and work on this branch, `git checkout dashboard-prototype`

![Consumer Chart](supplementary_images/dashboard_prototype.png)

Follow the process in Exercise 3 to extract an XML-based file from the workbook and view the diffs with the *Open Changes* feature (top right corner). You can see that information about the dashboard is contained within the <dashboard> tag. Information on the dashboard's configuration is also provided.
* Save the workbook
* Export it as a twbx
* Close the workbook
* In the terminal, type `git_tab.sh executive_dashboard.twbx`.
```
git add executive_dashboard.twb executive_dashboard.txt
git commit -m "added the prototype dashboard"
```

Finally, merge *dashboard-prototype* to main branch
```
git switch main
git merge dashboard-prototype # an input window might appear, but you can just close it
```
## Bonus Exercise: Resolve a Merge Conflict

*To simplify the tutorial, this section relies more on code than previous section.*

As you collaborate with teammates on Tableau projects, eventually you will run into *merge conflicts*. As the name suggest, a merge conflict happens when git doesn't know how to merge work together. The diagram below demonstrates such an example

![Merge Conflict Scenario](supplementary_images/merge_conflict.png)

In this scenario, two developers Alice and Bob both want to build the KPI viz in two different ways. (We won't discuss why they simultaneously build the viz as the purpose of this exercise is raise awareness of merge conflicts only.) They start by splitting off from the main branch and build up the viz from a blank sheet, Sheet 1. Alice, essentially completing Exercise 1, builds the viz without any format. Bob, on the other hand, completes the viz with all the required format (Exercise 2). Alice then wants to merge Bob's work into hers but a merge conflict happens because git doesn't know how to combine the two. After a meeting, they agree to finalize the KPI viz by using Bob's work.

Admittedly, this is an artificial scenario. However, merge conflicts do occur all the time, especially when there are multiple developers on the project. The proposed solution in this tutorial is to break down work into small, commitable changes for individuals, so that when a merge conflict happens, the team can come up with a reasonable solution, such as only using the version that the team agrees (i.e., Bob's version).

Follow the code below to understand a merge conflict scenario and how to resolve it.
```
# Copy/Paste the file here
# It'll serve as the starting point (before the divergence)
git switch main
cp bonus/merge_conflict_practice.twb ./merge_conflict_practice.twb

# Simulate the situation when a person, Alice, takes a branch from main 
git switch main
git checkout -b dev-Alice

# Simulate the situation when another person, Bob, takes a branch from main 
git switch main
git checkout -b dev-Bob

# Alice creates the KPI viz with no format done and then commits it
git switch dev-Alice
start merge_conflict_practice.twb # open this Tableau workbook, modify Sheet 1 so it becomes the KPI sheet with no format (exercise 1), then save it as KPI
git_tab.sh merge_conflict_practice.twbx
git add merge_conflict_practice.twb merge_conflict_practice.txt
git commit -m "KPI initial build by Alice; no format"

# Bob creates the KPI viz with format and then commmits it
git switch dev-Bob
start merge_conflict_practice.twb open this Tableau workbook, modify Sheet 1 so it becomes the KPI sheet with the format (exercise 2), then save it as KPI
git_tab.sh merge_conflict_practice.twbx
git add merge_conflict_practice.twb merge_conflict_practice.txt
git commit -m "KPI initial build by Bob; with format"

# Switch to Alice branch and merge Bob's work into it
# There will be a conflict as git won't know how to merge two files
# Click on merge_conflict_practice.txt to look at where the conflict happens 
git switch dev-Alice
git merge dev-Bob # conflict will arise due to the format in Bob's workbook

# This abort the merge, essentially returns the twb and txt to their stage before the merge
git merge --abort

# Tell git to keep the version from Bob
git switch dev-Alice
git checkout --theirs merge_conflict_practice.twb merge_conflict_practice.txt
git add merge_conflict_practice.twb merge_conflict_practice.txt
git commit -m "alice likes bob's version since bob's already figured out how to format the KPIs"
```
# Final Thoughts

In this tutorial, we explored techniques for performing version control with Tableau workbooks. I’d like to share additional thoughts in a Q&A format as I personally had these questions when I started this project.

**Q: Why does this workflow look so complex?**

A: It looks complex primarily because that's how Git works. In this tutorial, “doing version control with Tableau” simply means converting your Tableau workbooks (and Prep flows) into text files so that analysts can view any changes. Essentially, all you need to do is run the *git_tab.sh* script. Git then allows you to track changes to those text files and back up your work on a server like GitHub or GitLab. Fundamentally, not much has changed: you still need to talk to stakeholders, think about an appropriate design, and most importantly, use your mouse to create the dashboard.

**Q: So it sounds like I’m learning Git for version control and then apply it to Tableau. Is it really necessary to adapt my workflow this way?**

A: Yes, because it benefits everyone:

<u>How It Benefits the Company</u>: Nowadays, I think it’s in every company’s best interest to have an analytics team [1]. Such a team needs flexibility to address ever-changing business requirements. Depending on a single person who’s highly proficient in Tableau—while all the work is stored on their laptop—is risky. (What happens if that person gets sick or goes on vacation?) It’s better to have work backed up somewhere, well documented, and accessible to a secondary person who knows what’s going on.

Git’s decentralized model makes onboarding a new team member straightforward: just ask them to run `git clone` and they have all the existing work ready for inspection and collaboration. No more passing around workbooks [2]!

Since Git is optimized for collaboration, code documentation, and learning (through features like wikis), you can also document complex features and charts—preventing knowledge loss. Furthermore, from a strategic standpoint, being able to version-control Tableau artifacts means treating them as digital assets that can be mined later for intelligence, offering a competitive edge. Because Tableau workbooks and Prep flows can be extracted into XML files, they could even be fed into a chatbot powered by a Large Language Model (LLM). For instance, I often encounter questions like, “Is the formula that team X uses for this metric the same as the one team Y uses?” Having a chatbot to answer that would be incredibly helpful.

[1] Analytics doesn’t necessary mean to do kick-ass predictive modeling. For many departments, it can simply mean compiling data to generate a comprehensive figure, e.g. sales or profits, for last month and presenting it in a digestible format. Trying to inform our leadership of what has happened is still a big part of an analyst' job.

[2] Here, I’m not arguing whether this can be done via editing a published workbook on Tableau Cloud or Tableau Server. That would be an interesting discussion for a future article.

<u>How it benefits the individual</u>: I've seen a common career progression for data analysts is moving into data engineering or analytics engineering. This path requires not just knowledge of SQL or Python but also the ability to write code collaboratively and communicate with more technically inclined colleagues (e.g., senior data engineers). The MIT online course, The Missing Semester of Your CS Education (https://missing.csail.mit.edu/), highlights that version control with Git is one of the “missing” skills crucial for a successful engineering role. So, adopting Git early in your analyst career will pay off in the long run. Although Tableau’s user-friendly, drag-and-drop approach is fantastic for analysts, it’s often not perceived as “serious” engineering by developers. However, if you’re comfortable with Git, you’ll likely earn their respect. The ability to clone a project, navigate the repository, ask questions, and contribute is a huge career booster.

**Q: I noticed that vscode can open the twb file in xml format. Do I still need git_tab.sh to extract text from twb files?**

A: You're correct that vscode can open the twb file in xml format and thus, there's no need to use *git_tab.sh* to convert twb into txt. However, there are three reasons against this practice:

1. It's dangerous to view the twb file directly. You can accidentally add something while browsing it, which will corrupt the workbook without realizing it. It's much safer to view the accompanied text file.

2. It's very hard to read the text in the twb file as there are too many colors. Once the twb file is open, vscode recognizes the xml format due to the xml declaration at the beginning of the file. Then all the text are colorized differently depending on the its function (e.g. elements, tags, etc.), which really hurts the eyes. On the other hand, the txt file only has one color. This facilitates knowledge discovery as oftentimes, we're more interested in learning about the changes between different versions (aka, the diffs). Having one-color text makes it really easy to spot the diffs.

3. It's not possible to view a Tableau Prep flow directly. Unlike twb files, tfl files are binary. Thus, if you try to peek into it directly, you'll see a bunch of junk. As of this writing 1/30/2025, the only way to view the tfl files in a human-readable format is by extracting a txt file.

Thus, the purpose of *git_tab.sh* is to minimize the chance that you'll accidentally corrupt the twb files when viewing it directly, facilitate knowledge discovery, and allow a common method to quickly understand the diffs between versions for both twb and tfl files.

**Q: There are too many things to read in the extracted xml files. Is there a quicker way to read it?**

A: Yes. Use chatgpt(!) -- just dump it there. Chatgpt does a fine job at summarizing the text, telling you exactly what you need to know.

**Q: Where do I go from here?**

A: After completing this tutorial, start using these principles in your work. For example, if you have a Tableau project, migrate it into a GitHub or GitLab repository rather than letting it sit on your local machine. In your spare time, think about how to break down your work into small, committable changes. If you get stuck with Git, there’s probably a software engineer at your company who would be happy to help—nothing beats silo more than the ability to speak the same technical language. For example, in my own company, I brought up this idea to senior leads and received substantial help while navigating Git because they recognized its value. Prior to this, my work was fairly siloed—people knew who I was but didn’t really know what I did (which, I believe, is a scenario many analysts encounter). Learning Git will help break down those silos.

If you find this approach valuable, consider extending *git_tab.sh* into a true Git extension, so it can run like an actual Git command (e.g., git add) rather than just a script. I’d love to learn how you do that!

Last but not least, keep in mind that doing version control with Tableau workbooks is still relatively new. My team is experimenting with it, and I’m excited to share our implementation journey whenever I can. I also look forward to hearing about your own experiences as well.

--Tutorial written by Huy Truong