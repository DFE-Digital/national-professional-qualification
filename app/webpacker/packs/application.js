require.context('govuk-frontend/govuk/assets');
require.context('../images', true);

import '../styles/application.scss';
import { initAll } from 'govuk-frontend';

initAll();