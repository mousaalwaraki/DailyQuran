# DailyQuran

## Screenshots

<img src="https://github.com/mousaalwaraki/DailyQuran/blob/master/Screenshots/1.png" width="800">  
<img src="https://github.com/mousaalwaraki/DailyQuran/blob/master/Screenshots/2.png" width="800">
<img src="https://github.com/mousaalwaraki/DailyQuran/blob/master/Screenshots/3.png" width="400">  

## Summary

Taking advantage of caching I created a Quran app that allows the user to read a predetermined number of pages per day, chosen by the user.  
Using AVAudioPlayer, the user has the option to stream the audio files for the pages he/she wants to read.  
Implementing a UIPageController gives the Quran app a book like feel to make the user feel more like they are reading from a physical copy.  
On the iPad the user can take advantage of the larger screen by allowing 2 pages to be side by side simultaneously, and using mid spine location,
gives it a more realistic feel.  
Using caching the app can also track the longest consecutive streak of reading and the current streak to motivate the user to create a daily habit of reading.  
Recently added light and dark mode including for the images, without adding image assets and bloating up app size. By inverting the colors of the white page and
black text to a black page and white text the user gets dark mode support without comprimising storage.

## Challenges 

The main challenges faced during the creation of this app was allowing for 2 view controllers on landscape iPad, alongside a mid spine location. This was
particularly challenging for when the user chooses an odd number of pages for their daily reading.   
Another difficulty faced was due to it being a quran app (in Arabic), the page turning is in the different direction. This created plenty of challenges when
writing the app logic and mechanics, as the user needed to start on the 'last page' (due to it being written in english) then turning to the first page. This
also created challenges for when writing code for UIPageController functions.

## AppStore link and description 

Appstore link: https://apps.apple.com/us/app/daily-quran-bulid-a-habit/id1516253962

At Daily Quran we belive that the Quran holds immense value for mankind not only for religious purposes but also to improve day-to-day lives of humans, this is highlighted by Prophet Muhammed (PBUH) when he said: 

Whenever mischief and seditions surround you like a part of the darkness of the night then (take refuge and) go towards the Holy Quran.' 

There is importance in the Quran, not only reciting the Quran in a consistent matter, but also to encourage correct recitations. This is evident in the Quran: 

'…And recite the Quran with measured recitation. [Quran 73:4] 

also when Prophet Muhammed (PBUH) said: 

'Read the Quran, for verily it will come on the Day of Standing as an intercessor for its companions.' 

'These hearts rust just as iron rusts; and indeed they are polished through the recitation of the Qur’an.' 

This is why we at Daily Quran believe not only in encouraging daily reading, but also in giving the option of following a sheikh while reciting in order to correct mistakes and improve quality of recitations.
