# Overview 

This entry-level Hands-On Lab exercise is designed to help you master the basics of Coalesce. In this lab, you’ll explore the Coalesce interface, learn how to easily transform and model your data with our core capabilities, understand how to deploy and refresh version-controlled data pipelines, and build a ML Forecast node that forecasts sales values for a fiction food truck company.

## **What you’ll need** 

* A Snowflake [trial account](https://signup.snowflake.com/?utm_source=google&utm_medium=paidsearch&utm_campaign=na-us-en-brand-trial-exact&utm_content=go-eta-evg-ss-free-trial&utm_term=c-g-snowflake%20trial-e&_bt=579123129595&_bk=snowflake%20trial&_bm=e&_bn=g&_bg=136172947348&gclsrc=aw.ds&gclid=CjwKCAiAk--dBhABEiwAchIwkYotxMl4v5sRhNMO6LxCXUTaor9yH2mAbOwQHVO0ZNJQRuNyHrmYwRoCPucQAvD_BwE)  
* A Coalesce trial account created via [Snowflake Partner Connect](https://coalesce.io/product-technology/launch-coalesce-from-snowflake-partner-connect/)  
* Basic knowledge of SQL, database concepts, and objects  
* The [Google Chrome browser](https://www.google.com/chrome/)

## **What you’ll build** 

* A Directed Acyclic Graph (DAG) representing a basic star schema in Snowflake 

## **What you’ll learn** {#what-you’ll-learn}

* How to navigate the Coalesce interface  
* How to add data sources to your graph   
* How to prepare your data for transformations with Stage nodes  
* How to join tables  
* How to apply transformations to individual and multiple columns at once  
* How to build out Dimension and Fact nodes  
* How to make changes to your data and propagate changes across pipelines  
* How to configure and build an ML Forecast node

By completing the steps we’ve outlined in this guide, you’ll have mastered the basics of Coalesce and can venture into our more advanced features.

---

# About Coalesce 

Coalesce is the first cloud-native, visual data transformation platform built for Snowflake. Coalesce enables data teams to develop and manage data pipelines in a sustainable way at enterprise scale and collaboratively transform data without the traditional headaches of manual, code-only approaches.

## What can I do with Coalesce? 

With Coalesce, you can: 

* Develop data pipelines and transform data as efficiently as possible by coding as you like and automating the rest, with the help of an easy-to-learn visual interface  
* Work more productively with customizable templates for frequently-used transformations, auto-generated and standardized SQL, and full support for Snowflake functionality  
* Analyze the impact of changes to pipelines with built-in data lineage down to the column level  
* Build the foundation for predictable DataOps through automated CI/CD workflows and full git integration  
* Ensure consistent data standards and governance across pipelines, with data never leaving your Snowflake instance

## How is Coalesce different? 

Coalesce’s unique architecture is built on the concept of column-aware metadata, meaning that the platform collects, manages, and uses column- and table-level information to help users design and deploy data warehouses more effectively. This architectural difference gives data teams the best that legacy ETL and code-first solutions have to offer in terms of flexibility, scalability and efficiency.  

Data teams can define data warehouses with column-level understanding, standardize transformations with data patterns (templates) and model data at the column level.

Coalesce also uses column metadata to track past, current, and desired deployment states of data warehouses over time. This provides unparalleled visibility and control of change management workflows, allowing data teams to build and review plans before deploying changes to data warehouses.

## Core Concepts in Coalesce  

### **Snowflake** 

Coalesce currently only supports Snowflake as its target database, As you will be using a trial Coalesce account created via Partner Connect, your basic database settings will be configured automatically and you can instantly build code.

## **Organization**

A Coalesce organization is a single instance of the UI, set up specifically for a single prospect or customer. It is set up by a Coalesce administrator and is accessed via a username and password. By default, an organization will contain a single Project and a single user with administrative rights to create further users.

## **Projects** 

Projects provide a way of completely segregating elements of a build, including the source and target locations of data, the individual pipelines and ultimately the git repository where the code is committed. Therefore teams of users can work completely independently from other teams who are working in a different Coalesce Project. 

Each Project requires access to a git repository and Snowflake account to be fully functional. A Project will default to containing a single Workspace, but will ultimately contain several when code is branched.

## **Workspaces vs Environments**  

A Coalesce Workspace is an area where data pipelines are developed that point to a single git branch and a development set of Snowflake schemas. One or more users can access a single Workspace. Typically there are several Workspaces within a Project, each with a specific purpose (such as building different features). Workspaces can be duplicated (branched) or merged together.

A Coalesce Environment is a target area where code and job definitions are deployed to. Examples of an environment would include QA, PreProd and Production.

It isn’t possible to directly develop code in an Environment, only deploy to there from a particular Workspace (branch). Job definitions in environments can only be run via the CLI or API (not the UI). Environments are shared across an entire project, therefore the definitions are accessible from all workspaces. Environments should always point to different target schemas (and ideally different databases), than any Workspaces. 

# Lab Use Case 

As the lead Data & Analytics manager for TastyBytes Food Trucks, you're responsible for building and managing data pipelines that deliver insights to the rest of the company. There customer-related questions that the business needs to answer that will help with inventory planning and marketing. Included in this, is building a machine learning forecast that will allow management to determine sales volume for each item on the menu. 

In order to help your extended team answer these questions, you’ll need to build a customer data pipeline first.

---

# Before You Start 

To complete this lab, please create free trial accounts with Snowflake and Coalesce by following the steps below. You have the option of setting up Git-based version control for your lab, but this is not required to perform the following exercises. Please note that none of your work will be committed to a repository unless you set Git up before developing.

We recommend using Google Chrome as your browser for the best experience.

| Note: Not following these steps will cause delays and reduce your time spent in the Coalesce environment\! |
| :---- |

## Step 1: Create a Snowflake Trial Account  

1. Fill out the Snowflake trial account form [here](https://signup.snowflake.com/?utm_source=google&utm_medium=paidsearch&utm_campaign=na-us-en-brand-trial-exact&utm_content=go-eta-evg-ss-free-trial&utm_term=c-g-snowflake%20trial-e&_bt=579123129595&_bk=snowflake%20trial&_bm=e&_bn=g&_bg=136172947348&gclsrc=aw.ds&gclid=Cj0KCQiAtvSdBhD0ARIsAPf8oNm6YH7UeRqFRkVeQQ-3Akuyx2Ijzy8Yi5Om-mWMjm6dY4IpR1eGvqAaAg3MEALw_wcB). Use an email address that is not associated with an existing Snowflake account.   
     
2. When signing up for your Snowflake account, select the region that is physically closest to you and choose Enterprise as your Snowflake edition. Please note that the Snowflake edition, cloud provider, and region used when following this guide do not matter.   
  
![pic1](https://github.com/user-attachments/assets/77967a06-cbe7-410d-9b46-4357f7bdac3f)


3. After registering, you will receive an email from Snowflake with an activation link and URL for accessing your trial account. Finish setting up your account following the instructions in the email. 


## Step 2: Create a Coalesce Trial Account with Snowflake Partner Connect {#step-2:-create-a-coalesce-trial-account-with-snowflake-partner-connect}

Once you are logged into your Snowflake account, sign up for a free Coalesce trial account using Snowflake Partner Connect. Check your Snowflake account profile to make sure that it contains your fist and last name. 

Once you are logged into your Snowflake account, sign up for a free Coalesce trial account using Snowflake Partner Connect. Check your Snowflake account profile to make sure that it contains your fist and last name. 

1. Select Data Products \> Partner Connect in the navigation bar on the left hand side of your screen and search for Coalesce in the search bar.   
     
![pic2](https://github.com/user-attachments/assets/f9efe7d9-3970-4c5f-8d80-7d8741a9c2ec)

2. Review the connection information and then click Connect.
   
![pic3](https://github.com/user-attachments/assets/74875435-a12a-41c0-b5b4-9d3b0498d6bf)

4. When prompted, click Activate to activate your account. You can also activate your account later using the activation link emailed to your address.

   ![pic4](https://github.com/user-attachments/assets/9c24feb8-6c78-48ef-867f-85b1961fee48)

5. Once you’ve activated your account, fill in your information to complete the activation process.
   
![pic5](https://github.com/user-attachments/assets/750d628b-e130-4bab-b15d-2b72ddf6af9a)

Congratulations! You’ve successfully created your Coalesce trial account. 

## Step 3: Set Up The Dataset 

1. We will be using a M Warehouse size within Snowflake for this lab. You can upgrade this within the admin tab of your Snowflake account.

<img width="217" alt="pic6" src="https://github.com/user-attachments/assets/303ceacd-9da9-487a-8135-c57cda258c47" />

2. In your Snowflake account, click on the Worksheets Tab in the left-hand navigation bar.

![pic7](https://github.com/user-attachments/assets/cf6af0df-7895-4f73-934e-97bbfc2ecaf9)

3. Within Worksheets, click the "+" button in the top-right corner of Snowsight and choose "SQL Worksheet.”   
   
![pic8](https://github.com/user-attachments/assets/92b6897b-5b5e-4143-b2ef-c03457d2ca69)

4. Navigate to the [Cortex HOL Data Setup File](https://github.com/Snowflake-Labs/sf-samples/blob/main/samples/tasty_bytes/tb_introduction.sql?_fsi=g5nXkinG) that is hosted on GitHub.


5. Within GitHub, navigate to the right side and click "Copy raw contents". This will copy all of the required SQL into your clipboard.

   ![][image10]

6. Paste the setup SQL from GitHub into your Snowflake Worksheet. Then click inside the worksheet and select All (*CMD \+ A for Mac or CTRL \+ A for Windows*) and Click "► Run".

   ![][image11]

7. After clicking "► Run" you will see queries begin to execute. These queries will run one after another with the entire worksheet taking around 5 minutes. Upon completion you will see a message that states stating frostbyte\_tasty\_bytes setup is now complete.

![][image12]

Once you’ve activated your Coalesce trial account and logged in, you will land in your Projects dashboard. Projects are a useful way of organizing your development work by a specific purpose or team goal, similar to how folders help you organize documents in Google Drive. 

Your trial account includes a default Project to help you get started. Click on the Launch button next to your Development Workspace to get started.
