import { Route, Routes } from 'react-router';
import * as React from 'react';

const Layout = React.lazy(() => import('layout/Module'));
const Remote1 = React.lazy(() => import('remote1/Module'));
const Remote2 = React.lazy(() => import('remote2/Module'));

export function App() {
  return (
      <React.Suspense fallback={null}>
        <Routes>
          <Route element={<Layout />}>
            <Route index={true} element={<Remote1 />} />
            <Route path="/remote2" element={<Remote2 />} />
          </Route>
        </Routes>
      </React.Suspense>
  );
}

export default App;
