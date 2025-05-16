import { TestBed } from '@angular/core/testing';

import { HttpClientTestingModule } from '@angular/common/http/testing';
import { JokesService } from './jokes.service';

describe('JokesService', () => {
  let service: JokesService;

  beforeEach(() => {
      TestBed.configureTestingModule({
        imports: [HttpClientTestingModule],
        providers: [JokesService]
      });
      service = TestBed.get(JokesService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

});
