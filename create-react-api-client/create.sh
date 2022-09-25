#!/bin/bash

axios_base_api_url="process.env.API_BASE_URL || \"http://localhost:3001/\""

axios_type_content=$(
printf "import { AxiosRequestConfig } from \"axios\";

export type AxiosMethod = \"get\" | \"post\" | \"put\" | \"patch\" | \"delete\";

export type AxiosParams<T = unknown> = {
  method: AxiosMethod;
  url: string;
  data?: T;
  config?: AxiosRequestConfig<T>;
};
"
)

axios_content=$(
printf "import axios, {
  type AxiosError,
  type AxiosResponse,
  AxiosRequestConfig,
} from \"axios\";

import { AuthResponse, RefreshToken } from \"~/types/auth/auth.types\";

import { AxiosMethod, AxiosParams } from \"./axios.type\";

axios.defaults.baseURL = %s;

const refreshToken = async () => {
    // refresh token logic implementation
}

export async function sendRawRequest<T, R>(
  method: AxiosMethod,
  url: string,
  data?: T,
  config?: AxiosRequestConfig<T>
) {
  if (method === \"get\") return axios.get<T, AxiosResponse<R>>(url, config);
  return axios[method]<T, AxiosResponse<R>>(url, data, config);
}

export async function sendRequest<T = unknown, R = unknown>(
  request: AxiosParams<T>
) {
  const { method, url, data, config } = request;
  try {
    return await sendRawRequest<T, R>(method, url, data, config);
  } catch (error) {
    const axiosError = error as AxiosError;
    if (axiosError.response?.status === 401) {
      const success = await refreshToken();
      if (success) return sendRawRequest<T, R>(method, url, data, config);
    }
    throw error;
  }
}" "${1:-$axios_base_api_url}"
)

npm i axios;
mkdir -p src/api/
touch src/api/axios.type.ts
printf "%s" "$axios_type_content" | cat > src/api/axios.type.ts
touch src/api/axios.ts
printf "%s" "$axios_content" | cat > src/api/axios.ts