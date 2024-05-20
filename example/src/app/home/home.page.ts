import { Component } from '@angular/core';
import { IonHeader, IonToolbar, IonTitle, IonContent, IonButton } from '@ionic/angular/standalone';
import { PhotoViewer } from '@capacitor-community/photoviewer';

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
  standalone: true,
  imports: [IonButton, IonHeader, IonToolbar, IonTitle, IonContent],
})
export class HomePage {
  constructor() {}

  showSingle() {
    PhotoViewer.show({
      images: [{
        url: 'https://picsum.photos/id/237/200/300',
        title: 'Title'
      }],
      mode: 'one'
    })
  }

  showMultiple() {
    PhotoViewer.show({
      images: [
        {
          url: 'https://picsum.photos/id/237/200/300',
          title: 'Title'
        },
        {
          url: 'https://picsum.photos/id/238/200/300',
          title: 'Title'
        },
        {
          url: 'https://picsum.photos/id/239/200/300',
          title: 'Title'
        }
      ],
      mode: 'slider'
    })
  }

  showGallery() {
    PhotoViewer.show({
      images: [
        {
          url: 'https://picsum.photos/id/237/200/300',
          title: 'Title'
        },
        {
          url: 'https://picsum.photos/id/238/200/300',
          title: 'Title'
        },
        {
          url: 'https://picsum.photos/id/239/200/300',
          title: 'Title'
        }
      ],
      mode: 'gallery'
    })
  }

  showWithCustomHeaders() {
    PhotoViewer.show({
      images: [
        {
          url: 'https://picsum.photos/id/237/200/300',
          title: 'Title'
        },
        {
          url: 'https://picsum.photos/id/238/200/300',
          title: 'Title'
        },
      ],
      options: {
        customHeaders: {
          accept: 'image/jpeg, image/png, image/gif, image/webp, image/svg+xml, image/*;q=0.8, */*;q=0.5',
          cookie: 'session=foo;',
        },
      },
      mode: 'slider'
    })
  }
}
