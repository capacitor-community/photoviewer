## CAPACITOR 4 (Master)

🚨 Release 2.0.0-0 all platforms ->> 🚨
  This is a tentative of implementing @Capacitor/core@4.0.1 proposed by rdlabo (Masahiko Sakakibara). 
  For those who want to try it do
  ```
  npm install @capacitor-community/photoviewer@next
  ```
  Revert quickly any issue by clearly mentionning V4 in the title of the issue.

  Thanks for your help in testing

🚨 Release 2.0.0-0 <<- 🚨

## CAPACITOR 3 (v1.1.3)

🚨 Since release 1.0.8 ->> 🚨

 - Add mode `slider` 
 - the call to the method show has been modified as follows;
 ```js
     const show = async (imageList: Image[], mode: string,
              startFrom: number, options?: ViewerOptions): Promise<capShowResult> => {
 ```
with 
 - mode in ["one","gallery","slider"]
 - startFrom: imageIndex in the imageList table valid only for mode "one" & mode "slider"
 
🚨 Since release 1.0.8 <<- 🚨
