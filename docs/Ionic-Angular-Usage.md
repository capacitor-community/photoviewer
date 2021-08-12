<p align="center"><br><img src="https://user-images.githubusercontent.com/236501/85893648-1c92e880-b7a8-11ea-926d-95355b8175c7.png" width="128" height="128" /></p>
<h2 align="center">IONIC/ANGULAR USAGE DOCUMENTATION</h2>
<p align="center"><strong><code>@capacitor-community/photoviewer</code></strong></p>
<p align="center">
  In Ionic/Angular Applications, the <code>@capacitor-community/photoviewer</code> can be accessed in component file</p>
<br>

## PhotoViewer Usage

### In the main.ts file

```js
import { enableProdMode } from '@angular/core';
import { platformBrowserDynamic } from '@angular/platform-browser-dynamic';

import { AppModule } from './app/app.module';
import { environment } from './environments/environment';
import { defineCustomElements as jeepPhotoviewer} from 'jeep-photoviewer/loader';
import { defineCustomElements as pwaElements} from '@ionic/pwa-elements/loader';

if (environment.production) {
  enableProdMode();
}
jeepPhotoviewer(window);
pwaElements(window);

platformBrowserDynamic().bootstrapModule(AppModule)
  .catch(err => console.log(err));

```
### In the app.module.ts file

```js
import { CUSTOM_ELEMENTS_SCHEMA, NgModule } from '@angular/core';
import { BrowserModule } from '@angular/platform-browser';
import { RouteReuseStrategy } from '@angular/router';

import { IonicModule, IonicRouteStrategy } from '@ionic/angular';

import { AppComponent } from './app.component';
import { AppRoutingModule } from './app-routing.module';

@NgModule({
  declarations: [AppComponent],
  entryComponents: [],
  imports: [BrowserModule, IonicModule.forRoot(), AppRoutingModule],
  providers: [{ provide: RouteReuseStrategy, useClass: IonicRouteStrategy }],
  bootstrap: [AppComponent],
  schemas: [CUSTOM_ELEMENTS_SCHEMA],
})
export class AppModule {}

```

### In the home.page.html file

```html
<ion-header [translucent]="true">
  <ion-toolbar>
    <ion-title>
      Home
    </ion-title>
  </ion-toolbar>
</ion-header>

<ion-content [fullscreen]="true">
  <ion-header collapse="condense">
    <ion-toolbar>
      <ion-title size="large">Home</ion-title>
    </ion-toolbar>
  </ion-header>

  <div id="container">
    <app-photoviewer></app-photoviewer>
  </div>
</ion-content>

```

### In the home.module.ts file

```js
import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IonicModule } from '@ionic/angular';
import { FormsModule } from '@angular/forms';
import { HomePage } from './home.page';
import { PhotoviewerComponentModule } from '../components/photoviewer/photoviewer.module';
import { HomePageRoutingModule } from './home-routing.module';


@NgModule({
  imports: [
    CommonModule,
    FormsModule,
    IonicModule,
    PhotoviewerComponentModule,
    HomePageRoutingModule
  ],
  declarations: [HomePage]
})
export class HomePageModule {}
```

### Generate a component in components/photoviewer

 - in the `photoviewer.module.ts` file

 ```js
    import { NgModule } from '@angular/core';
    import { CommonModule } from '@angular/common';
    import { FormsModule } from '@angular/forms';

    import { IonicModule } from '@ionic/angular';

    import { PhotoviewerComponent } from './photoviewer.component';

    @NgModule({
    imports: [ CommonModule, FormsModule, IonicModule],
    declarations: [PhotoviewerComponent],
    exports: [PhotoviewerComponent]
    })
    export class PhotoviewerComponentModule {}
 ```

 - in the `photoviewer.component.html`file 

 ```html
    <div id="photoviewer-container">
    </div>
 ```

 - int `photoviewer.component.ts`file
 
 ```js
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { PhotoViewer, Image, ViewerOptions, capEchoResult,
  capShowOptions, capShowResult} from '@capacitor-community/photoviewer';
import { Capacitor } from '@capacitor/core';
import { Toast } from '@capacitor/toast';

@Component({
  selector: 'app-photoviewer',
  templateUrl: './photoviewer.component.html',
  styleUrls: ['./photoviewer.component.scss'],
})
export class PhotoviewerComponent implements OnInit, AfterViewInit {
  platform: string;
  imageList: Image[];
  options: ViewerOptions = {} as ViewerOptions;

  constructor() {
    this.platform = Capacitor.getPlatform();
   }

  async ngOnInit() {
    this.imageList = [
      {url: 'https://i.ibb.co/wBYDxLq/beach.jpg', title: 'Beach Houses'},
      {url: 'https://i.ibb.co/gM5NNJX/butterfly.jpg', title: 'Butterfly'},
      {url: 'https://i.ibb.co/10fFGkZ/car-race.jpg', title: 'Car Racing'},
      {url: 'https://i.ibb.co/ygqHsHV/coffee-milk.jpg', title: 'Coffee with Milk'},
      {url: 'https://i.ibb.co/7XqwsLw/fox.jpg', title: 'Fox'},
      {url: 'https://i.ibb.co/L1m1NxP/girl.jpg', title: 'Mountain Girl'},
      {url: 'https://i.ibb.co/wc9rSgw/desserts.jpg', title: 'Desserts Table'},
      {url: 'https://i.picsum.photos/id/1009/5000/7502.jpg?hmac=Uj6crVILzsKbyZreBjHuMiaq_-n30qoHjqP0i7r30r8', title: 'Surfer'},
      {url: 'https://i.picsum.photos/id/1011/5472/3648.jpg?hmac=Koo9845x2akkVzVFX3xxAc9BCkeGYA9VRVfLE4f0Zzk', title: 'On a Lac'},
      {url: 'https://i.ibb.co/wdrdpKC/kitten.jpg', title: 'Kitten'},
      {url: 'https://i.ibb.co/dBCHzXQ/paris.jpg', title: 'Paris Eiffel'},
      {url: 'https://i.ibb.co/JKB0KPk/pizza.jpg', title: 'Pizza Time'},
      {url: 'https://i.ibb.co/VYYPZGk/salmon.jpg', title: 'Salmon '},
    ];
  }
  async ngAfterViewInit() {
    const show = async (imageList: Image[], options?: ViewerOptions): Promise<capShowResult> => {
      const opt: capShowOptions = {} as capShowOptions;
      opt.images = imageList;
      if(options) {
        opt.options = options;
      }
      try {
          const ret = await PhotoViewer.show(opt);
          console.log(`in const show ret: ${JSON.stringify(ret)}`);
          if(ret.result) {
              console.log(`in const show ret true: ${JSON.stringify(ret)}`);
              return Promise.resolve(ret);
          } else {
              console.log(`in const show ret false: ${JSON.stringify(ret)}`);
              return Promise.reject(ret.message);
          }
      } catch (err) {
          const ret: capShowResult = {} as capShowResult;
          ret.result = false;
          ret.message = err.message;
          console.log(`in const show catch err: ${JSON.stringify(ret)}`);
          return Promise.reject(err.message);
      }
    };
    const showToast = async (message: string) => {
      await Toast.show({
          text: message,
          position: 'center',
      });
    };

    const echo = await PhotoViewer.echo({value:'Hello from PhotoViewer'});
    console.log(`echo ${echo.value}`);
    if(!echo.value) {
      await showToast('no value to echo');
    } else {
      await showToast(`echo ${echo.value}`);
    }
    try {
      // **************************************
      // here you defined the different options
      // **************************************
      // uncomment the following desired lines below
      // options.title = false;
      // options.share = false;
      // options.transformer = "depth";
      // options.spancount = 2
      this.options.maxzoomscale = 3;
      this.options.compressionquality = 0.6;
      this.options.movieoptions = {mode: 'portrait', imagetime: 3};
      // **************************************
      // here you defined url or Base64 images
      // **************************************
      // comment or uncomment as you wish
      // http images call
      const result = await show(this.imageList, this.options);
      console.log(`after show ret: ${JSON.stringify(result)}`);
      // base64 images call
      //ret = await show(base64List, options);
      if(!result.result) {
          await showToast(JSON.stringify(result));
      }
      if(result.result && Object.keys(result).includes('message')) {
          await showToast(JSON.stringify(result));
      }
    } catch (err) {
        console.log(`in catch before toast err: ${err}`);
        await showToast(err);
        if(this.platform === 'web' || this.platform === 'electron') {
            window.location.reload();
        }
    }

  }
}
 ```

