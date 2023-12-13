defmodule DaisyUIForms.StorageBehaviour do
  @doc """
  Generate a signed URL to be used as previous value when a file
  input component is used
  """
  @callback get_signed_url(value_stored :: String.t()) :: String.t()
end
