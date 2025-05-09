import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { Joke } from '../model/joke.model';
import { environment } from '../../environments/environment.prod';

@Injectable({
  providedIn: 'root'
})
export class JokesService {

  private pathService = `${environment.apiUrl}/joke`;

  private subject: BehaviorSubject<Joke | null> = new BehaviorSubject<Joke | null>(null);

  constructor(private httpClient: HttpClient) {
    this.getRandomJoke();
  }

  public getRandomJoke(): void {
    this.httpClient.get<Joke>(this.pathService).subscribe((joke: Joke) => this.subject.next(joke));
  }

  public joke$(): Observable<Joke | null > {
    return this.subject.asObservable();
  }
}
