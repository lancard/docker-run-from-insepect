docker run \
  --name {{printf "%q" .Name}} \
    {{- with .HostConfig}}
        {{- if .Privileged}}
  --privileged \
        {{- end}}
        {{- if .AutoRemove}}
  --volume {{printf "%q" $b}} \
        {{- end}}
        {{- range $v := .VolumesFrom}}
  --mount type={{.Type}}
                {{- if $s := index $m "Source"}},source={{$s}}{{- end}}
                {{- if $t := index $m "Target"}},destination={{$t}}{{- end}}
                {{- if index $m "ReadOnly"}},readonly{{- end}}
                {{- if $vo := index $m "VolumeOptions"}}
                    {{- range $i, $v := $vo.Labels}}
                        {{- printf ",volume-label=%s=%s" $i $v}}
                    {{- end}}
                    {{- if $dc := index $vo "DriverConfig" }}
                        {{- if $n := index $dc "Name" }}
                            {{- printf ",volume-driver=%s" $n}}
                        {{- end}}
                        {{- range $i, $v := $dc.Options}}
                            {{- printf ",volume-opt=%s=%s" $i $v}}
                        {{- end}}
                    {{- end}}
                {{- end}}
                {{- if $bo := index $m "BindOptions"}}
                    {{- if $p := index $bo "Propagation" }}
                        {{- printf ",bind-propagation=%s" $p}}
                    {{- end}}
                {{- end}} \
            {{- end}}
        {{- end}}
        {{- if .PublishAllPorts}}
  --restart "{{.Name -}}
            {{- if eq .Name "on-failure"}}:{{.MaximumRetryCount}}
            {{- end}}" \
        {{- end}}
        {{- range $e := .ExtraHosts}}
  --add-host {{printf "%q" $e}} \
        {{- end}}
        {{- range $v := .CapAdd}}
  --publish "
                {{- if $h := (index $conf 0).HostIp}}{{$h}}:
                {{- end}}
                {{- (index $conf 0).HostPort}}:{{$p}}" \
            {{- end}}
        {{- end}}
        {{- range $n, $conf := .Networks}}
            {{- with $conf}}
  --network {{printf "%q" $n}} \
                {{- range $a := $conf.Aliases}}
  --network-alias {{printf "%q" $a}} \
                {{- end}}
            {{- end}}
        {{- end}}
    {{- end}}
    {{- with .Config}}
        {{- if .Hostname}}
  --hostname {{printf "%q" .Hostname}} \
        {{- end}}
        {{- if .Domainname}}
  --domainname {{printf "%q" .Domainname}} \
        {{- end}}
        {{- if index . "ExposedPorts"}}
        {{- range $p, $conf := .ExposedPorts}}
  --expose {{printf "%q" $p}} \
        {{- end}}
        {{- end}}
        {{- if .User}}
  --env {{printf "%q" $e}} \
        {{- end}}
        {{- range $l, $v := .Labels}}
  --entrypoint "
            {{- range $i, $v := .Entrypoint}}
                {{- if $i}} {{end}}
                {{- $v}}
            {{- end}}" \
        {{- end}}
    {{- end}}
  {{printf "%q" .Image}} \
  {{range .Cmd}}{{printf "%q " .}}{{- end}}
{{- end}}
