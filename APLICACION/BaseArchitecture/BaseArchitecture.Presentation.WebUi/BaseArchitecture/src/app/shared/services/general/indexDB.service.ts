import { Injectable } from '@angular/core';
import { openDB, DBSchema, IDBPDatabase } from 'idb';

@Injectable({ providedIn: 'root' })
export class IndexdDBService {
  private db: IDBPDatabase<any>;

  constructor() {
    this.connectToDb();
  }

  async connectToDb() {
    this.db = await openDB<MyDB>('antamina-digital-db', 1, {
      upgrade(db) {
        db.createObjectStore('user-store', {
          keyPath: 'CodCia',
          autoIncrement: true,
        });
      },
    });
  }

  addStore(val: any) {
    return this.db.put('user-store', val);
  }

  clearStore() {
    return new Promise(function (resolve, reject) {
      var myDB = window.indexedDB.open('antamina-digital-db');
      myDB.onsuccess = (event: any) => {
        event.currentTarget.result
          .transaction('user-store', 'readwrite')
          .objectStore('user-store')
          .clear();

        resolve();
      };

      myDB.onerror = (err) => {
        reject(err);
      };
    });
  }
}

interface MyDB extends DBSchema {
  'user-store': {
    key: string;
    value: {
      CodCia: string;
      body: any;
    };
  };
}
