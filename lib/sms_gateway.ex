defmodule SMSGateway do

  def send_sms(sms_content) do
    # Complicated sms sending things

    send(self(), {:sms_sent, sms_content})
  end
end
