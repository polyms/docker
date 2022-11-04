import React from "react";
import { createRoot } from "react-dom/client";
import CssBaseline from "@mui/material/CssBaseline";
import { DockerMuiThemeProvider } from "@docker/docker-mui-theme";

import { App } from "./App";

const root = createRoot(document.getElementById("root")!);

root.render(
  <React.StrictMode>
    {/*
      If you eject from MUI (which we don't recommend!), you should add
      the `dockerDesktopTheme` class to your root <html> element to get
      some minimal Docker theming.
    */}
    <DockerMuiThemeProvider>
      <CssBaseline />
      <App />
    </DockerMuiThemeProvider>
  </React.StrictMode>
);
