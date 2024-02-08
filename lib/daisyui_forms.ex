defmodule DaisyUIForms do
  @moduledoc """
  Form helpers using DaisyUI classes
  """

  use Phoenix.HTML

  @doc """
  Generate the required html for an input field
  """
  @spec input(Phoenix.HTML.Form.t(), atom, Keyword.t()) :: [tuple]
  def input(form, field, opts \\ []) do
    type = Phoenix.HTML.Form.input_type(form, field)
    wrapper_opts = [class: "form-control w-full max-w-xs"]
    label_text = Keyword.get(opts, :label, humanize(field))

    content_tag :div, wrapper_opts do
      label = label(form, field, label_text, class: "label")
      error = error_tag(form, field)

      input_opts =
        case error do
          [] -> [class: "input input-bordered input-sm w-full max-w-xs"]
          _ -> [class: "input input-bordered input-sm w-full max-w-xs input-error"]
        end

      input = apply(Phoenix.HTML.Form, type, [form, field, Keyword.merge(input_opts, opts)])

      [label, input, error || ""]
    end
  end

  @doc """
  Generate the required html for an textarea field
  """
  @spec textarea(Phoenix.HTML.Form.t(), atom, Keyword.t()) :: [tuple]
  def textarea(form, field, opts \\ []) do
    wrapper_opts = [class: "form-control w-full max-w-xs"]
    label_text = Keyword.get(opts, :label, humanize(field))

    content_tag :div, wrapper_opts do
      label = label(form, field, label_text, class: "label")
      error = error_tag(form, field)

      input_opts =
        case error do
          [] -> [class: "textarea textarea-bordered textarea-sm"]
          _ -> [class: "textarea textarea-bordered textarea-sm input-error"]
        end

      input = apply(Phoenix.HTML.Form, :textarea, [form, field, Keyword.merge(input_opts, opts)])

      [label, input, error || ""]
    end
  end

  @doc """
  Create a select using the given choices
  """
  @spec select(Phoenix.HTML.Form.t(), atom, [tuple], any, String.t()) :: [tuple]
  def select(form, field, choices, selected, prompt \\ nil) do
    wrapper_opts = [class: "form-group w-full max-w-xs"]

    content_tag :div, wrapper_opts do
      label = label(form, field, humanize(field), class: "label")
      error = error_tag(form, field)

      input_opts =
        case error do
          [] -> [class: "select select-bordered select-sm w-full max-w-xs"]
          _ -> [class: "select select-bordered select-sm w-full max-w-xs input-error"]
        end

      input_opts =
        case prompt do
          nil -> input_opts
          _ -> Keyword.put(input_opts, :prompt, prompt)
        end

      select =
        Phoenix.HTML.Form.select(
          form,
          field,
          choices,
          Keyword.merge([selected: selected], input_opts)
        )

      [label, select, error || ""]
    end
  end

  @doc """
  Generate the required html for an file inpurt
  """
  @spec file_input(Phoenix.HTML.Form.t(), atom, String.t(), Keyword.t()) :: [tuple]
  def file_input(form, field, value, opts \\ []) do
    wrapper_opts = [class: "form-control w-full max-w-xs"]
    label_text = Keyword.get(opts, :label, humanize(field))

    content_tag :div, wrapper_opts do
      label = label(form, field, label_text, class: "label")
      error = error_tag(form, field)

      input_opts =
        case error do
          [] -> [class: "file-input file-input-bordered file-input-sm w-full max-w-xs"]
          _ -> [class: "file-input file-input-bordered file-input-sm w-full max-w-xs input-error"]
        end

      input =
        apply(Phoenix.HTML.Form, :file_input, [form, field, Keyword.merge(input_opts, opts)])

      prev_data =
        if is_nil(value) do
          ""
        else
          storage = Keyword.get(opts, :storage)

          unless Code.ensure_loaded?(storage) do
            raise "Defined storage for DaisyUIForms.file_input/4 is invalid"
          end

          {:ok, url} = storage.get_signed_url(value)

          content_tag :a, href: url do
            [value]
          end
        end

      [label, input, prev_data, error || ""]
    end
  end

  @spec error_tag(Phoenix.HTML.Form.t(), atom) :: [tuple]
  defp error_tag(form, field) do
    Enum.map(Keyword.get_values(form.errors, field), fn error ->
      content_tag(:span, translate_error(error),
        class: "invalid-feedback",
        phx_feedback_for: input_name(form, field)
      )
    end)
  end

  @error_message """
  Missing gettext_module config. Add the following to your config/config.exe

  config :daisyui_forms, gettext_module: YourApp.Gettext
  """

  defp translate_error({msg, opts}) do
    module = Application.get_env(:daisyui_forms, :gettext_module)

    unless Code.ensure_loaded?(module) do
      raise ArgumentError, message: @error_message
    end

    if count = opts[:count] do
      Gettext.dngettext(module, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(module, "errors", msg, opts)
    end
  end
end
