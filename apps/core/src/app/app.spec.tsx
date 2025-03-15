import { BrowserRouter } from 'react-router';
import { render, waitFor} from '@testing-library/react';

import App from './app';

describe('App', () => {
  it('should render successfully', async () => {
      const { baseElement } = render(
          <BrowserRouter>
            <App />
          </BrowserRouter>
      );
      await waitFor(() => expect(baseElement).toBeTruthy());
  });

  it('should have a greeting as the title', async () => {
    const { getByText } = render(
      <BrowserRouter>
        <App />
      </BrowserRouter>
    );
    await waitFor(() => {
      expect(getByText(/welcome home/i)).toBeTruthy();
    });
  });
});
